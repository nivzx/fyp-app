import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> sendDatatoAPI(
      double lat, double long, double signalLevel) async {
    final Map<String, dynamic> dataTel = {
      "lat": lat,
      "long": long,
      "level": signalLevel,
    };

    final response = await http.post(
      Uri.parse('http://192.168.8.121:33000/incoming-data'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dataTel),
    );

    if (response.statusCode == 200) {
      print('Response: ${response.body}');
    } else {
      print('Error occurred: ${response.statusCode}');
    }
  }
}
