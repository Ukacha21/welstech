import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorPage(),
    );
  }
}

class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double? temperature;
  double? humidity;

  void getData() async {
    try {
      var data = await ApiService.fetchSensorData();
      setState(() {
        temperature = data['temp'];
        humidity = data['hum'];
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ESP32 Sensor Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Temperature: ${temperature?.toStringAsFixed(1) ?? '--'} °C"),
            Text("Humidity: ${humidity?.toStringAsFixed(1) ?? '--'} %"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getData,
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
