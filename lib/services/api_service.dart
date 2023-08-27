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
      Uri.parse('http://172.20.10.7:33000/incoming-data'),
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
          'http://172.20.10.7:4000/channels/mychannel/chaincodes/fabcar?args=["-75"]&peer=peer0.org1.example.com&fcn=getHighLocations'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<void> sendTokenLocation(
      String? token, double lat, double long) async {
    // Concatenate and round latitude and longitude
    String latLongConcatenated =
        '${lat.toStringAsFixed(3)}_${long.toStringAsFixed(3)}';

    // Create the request body
    Map<String, dynamic> requestBody = {
      "fcn": "writeToken",
      "peers": ["peer0.org1.example.com", "peer0.org2.example.com"],
      "chaincodeName": "token",
      "channelName": "mychannel",
      "args": [token, latLongConcatenated]
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(requestBody);

    print("\x1B[31m $requestBodyJson \x1B[0m");

    // Set up the POST request
    Uri url = Uri.parse(
        'http://172.20.10.7:4000/channels/mychannel/chaincodes/token');
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBodyJson,
    );

    // Check the response
    if (response.statusCode == 200) {
      print('Token location sent successfully');
    } else {
      print(
          'Error sending token location. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
