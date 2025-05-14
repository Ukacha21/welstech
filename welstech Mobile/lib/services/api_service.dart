import 'package:http/http.dart' as http;
import 'dart:convert';

//api service - this moduel works with wifi

class ApiService {
  static const String baseUrl = 'http://<esp32s3.local>'; // Replace with your ESP32 IP

  static Future<Map<String, dynamic>> fetchSensorData() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      dynamic try_response = json.decode(response.body);
      if (try_response.length > 8) {
        
      }
      else {
        return try_response;
      }
      throw Exception("Nothing:)");
       
    } else {
      throw Exception('Failed to load data');
    }
  }
}
