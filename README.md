**Setup instructions for nodejs server
**  you'll need to set up a Node.js server with the following:

    Express.js for handling HTTP requests.
    MySQL for the database to store temperature and humidity records.
    body-parser for parsing incoming JSON requests.
    moment for handling date and time.

    Setup MySQL Database
First, create a MySQL database and table to store temperature and humidity records. Here is the SQL to create the database and table:

Database Connection:

    The MySQL database connection is established using the mysql library.

Endpoints:

    POST /temperature-humidity: Receives temperature and humidity data, gets the current date and time, and inserts a new record into the readings table.
    GET /readings: Fetches records from the readings table based on the current date and time.

Middleware:

    body-parser is used to parse JSON data from incoming requests.

Error Handling:

    Basic error handling is implemented for database operations.


**C++ emulator program**

we'll use C++ with the help of some libraries:

    Boost.Asio for asynchronous networking.
    cpp-httplib for HTTP server and client functionalities.
    nlohmann/json for JSON handling.
    <random> for generating random temperature and humidity values.

Flutter app:
Set up Flutter environment.
Make sure you have Flutter installed. Follow the installation guide from the official Flutter website.


**Create a new Flutter project.
**
dependencies:
  flutter:
    sdk: flutter
  http: ^0.14.0
Run flutter pub get to install the new dependency.

Dependencies:

    The http package is used for making HTTP requests.

UI Layout:

    The app has three buttons (START, STOP, GET LATEST) and two text fields to display temperature and humidity.

HTTP Requests:

    sendRequest(String endpoint): Sends START or STOP requests to the Node.js server.
    getLatest(): Sends a request to fetch the latest temperature and humidity data and updates the UI.

State Management:

    The temperature and humidity variables are updated using setState to trigger a UI refresh.

    
