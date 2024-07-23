import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

// Main widget of the app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// Home page widget with state
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String temperature = ''; // Variable to store temperature
  String humidity = ''; // Variable to store humidity

  // Function to send a request to the backend with a specified endpoint
  void sendRequest(String endpoint) async {
    final response = await http.get(Uri.parse('http://cloud.co.in:9000/$endpoint'));
    if (response.statusCode == 200) {
      print('Success: $endpoint'); // Log success if the request was successful
    } else {
      print('Failed: $endpoint'); // Log failure if the request failed
    }
  }

  // Function to get the latest sensor data from the backend
  void getLatest() async {
    final response = await http.get(Uri.parse('http://cloud.co.in:9000/latest'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Decode the JSON response
      setState(() {
        temperature = data['temperature'].toString(); // Update temperature
        humidity = data['humidity'].toString(); // Update humidity
      });
    } else {
      print('Failed to get latest data'); // Log failure if the request failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor App'), // Title of the app bar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // START button
            ElevatedButton(
              onPressed: () => sendRequest('START'), // Call sendRequest with 'START' endpoint
              child: Text('START'),
            ),
            // STOP button
            ElevatedButton(
              onPressed: () => sendRequest('STOP'), // Call sendRequest with 'STOP' endpoint
              child: Text('STOP'),
            ),
            // GET LATEST button
            ElevatedButton(
              onPressed: getLatest, // Call getLatest function
              child: Text('GET LATEST'),
            ),
            SizedBox(height: 20), // Space between buttons and sensor data
            // Display temperature
            Text(
              'Temperature: $temperature °C',
              style: TextStyle(fontSize: 20),
            ),
            // Display humidity
            Text(
              'Humidity: $humidity %',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
