import 'package:http/http.dart' as http;

class EspAccessPointClient {
  final String espIp;
  final int port;

  EspAccessPointClient({this.espIp = '192.168.4.1', this.port = 80});

  /// Fetches the "Hello" message from ESP32 via HTTP GET
  Future<String> fetchHelloFromESP() async {
    final uri = Uri.parse('http://$espIp:$port/');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        print(response.body.trim());
        return response.body.trim();
      } else {
        return "❌ Error: ${response.statusCode}";
      }
    } catch (e) {
      print("⚠️ HTTP error: $e");
      return "❌ Connection error: $e";
    }
  }
}
