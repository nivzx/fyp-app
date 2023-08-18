class DummyService {
  //Get random location for testing
  static Future<List<dynamic>> getDummyLocations() async {
    List<dynamic> data = [
      {"location": "6.0350_80.2150", "level": -52.365},
      {"location": "6.0360_80.2160", "level": -30.365},
      {"location": "6.0456_80.2160", "level": -9.99},
      {"location": "6.0556_80.2170", "level": -9.99},
    ];

    return data;
  }
}
