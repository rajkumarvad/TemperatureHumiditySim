import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String temperature = '';
  String humidity = '';

  void sendRequest(String endpoint) async {
    final response = await http.get(Uri.parse('http://cloud.co.in:9000/$endpoint'));
    if (response.statusCode == 200) {
      print('Success: $endpoint');
    } else {
      print('Failed: $endpoint');
    }
  }

  void getLatest() async {
    final response = await http.get(Uri.parse('http://cloud.co.in:9000/latest'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = data['temperature'].toString();
        humidity = data['humidity'].toString();
      });
    } else {
      print('Failed to get latest data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => sendRequest('START'),
              child: Text('START'),
            ),
            ElevatedButton(
              onPressed: () => sendRequest('STOP'),
              child: Text('STOP'),
            ),
            ElevatedButton(
              onPressed: getLatest,
              child: Text('GET LATEST'),
            ),
            SizedBox(height: 20),
            Text(
              'Temperature: $temperature °C',
              style: TextStyle(fontSize: 20),
            ),
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
