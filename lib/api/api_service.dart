import 'dart:convert'; // For JSON decoding

import 'package:http/http.dart'; // For HTTP requests

// Extension to add a success check to the HTTP Response class
extension MyApiResponse on Response {
  // Returns true if the status code is 200 or 201
  bool get isSuccess => statusCode == 200 || statusCode == 201;
}

// Abstract class for API service
abstract class ApiService {
  // Base URL for the OpenWeatherMap API
  static const baseUrl = 'https://api.openweathermap.org/';
  
  // Abstract getter for the specific API endpoint
  String get apiUrl;
  
  // Combines base URL and API endpoint
  String get url => baseUrl + apiUrl;

  // Fetches data from the API using the provided endpoint
  Future<dynamic> fetch(String? endPoint) async {
    // Sends a GET request to the constructed URL
    var response = await get(Uri.parse('$url$endPoint'));
    // If the response is successful, decode and return the JSON body
    // Otherwise, throw an exception
    return response.isSuccess
        ? jsonDecode(response.body)
        : throw Exception('response isnot sucessful');
  }
}
