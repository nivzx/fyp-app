import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<void> sendDatatoAPI(
      double lat, double long, int signalLevel) async {
    final Map<String, dynamic> dataTel = {
      "lat": lat,
      "long": long,
      "level": signalLevel,
    };

    final response = await http.post(
      // Uri.parse('http://192.168.8.121:33000/incoming-data'),
      Uri.parse('http://172.23.126.29:33000/incoming-data'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dataTel),
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('Response: ${response.body}');
    } else {
      // ignore: avoid_print
      print('Error occurred: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> getHighLocations() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.8.121:4000/channels/mychannel/chaincodes/fabcar?args=["-75"]&peer=peer0.org1.example.com&fcn=getHighLocations'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
