#include <iostream>
#include <thread>
#include <random>
#include <chrono>
#include <boost/asio.hpp>
#include <httplib.h>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

std::atomic<bool> timer_running(false);

void send_data_to_cloud(const std::string &endpoint, int temp, int humidity) {
    httplib::Client cli("cloud.co.in", 9000);
    json data;
    data["temperature"] = temp;
    data["humidity"] = humidity;
    cli.Post(endpoint.c_str(), data.dump(), "application/json");
}

void generate_and_send_data(const std::string &endpoint) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> temp_dist(-10, 50);
    std::uniform_int_distribution<> humidity_dist(0, 100);

    int temp = temp_dist(gen);
    int humidity = humidity_dist(gen);
    send_data_to_cloud(endpoint, temp, humidity);
}
//Timer ISR
void start_timer(const std::string &endpoint) {
    while (timer_running) {
        generate_and_send_data(endpoint);
        std::this_thread::sleep_for(std::chrono::seconds(5));
    }
}

int main() {
    httplib::Server server;
    //HTTP endpoint handling START msg from cloud
    server.Get("/START", [](const httplib::Request &, httplib::Response &res) {
        if (!timer_running) {
            timer_running = true;
            std::thread(start_timer, "/temp").detach();
        }
        res.set_content("Timer started", "text/plain");
    });
    
    //HTTP endpoint handling STOP msg from cloud
    server.Get("/STOP", [](const httplib::Request &, httplib::Response &res) {
        timer_running = false;
        res.set_content("Timer stopped", "text/plain");
    });
    
    //HTTP endpoint handling STATUS msg from cloud
    server.Get("/STATUS", [](const httplib::Request &, httplib::Response &res) {
        generate_and_send_data("/temp");
        res.set_content("Status sent to cloud", "text/plain");
    });

    std::cout << "Server started at http://embedded.co.in:8000" << std::endl;
    server.listen("0.0.0.0", 8000);

    return 0;
}
