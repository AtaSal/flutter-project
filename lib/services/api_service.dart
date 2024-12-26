import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart'; // Ensure this imports where shrePref is defined

class ApiService {
  final String baseUrl = "http://feeds.ppu.edu/api/v1"; // Use https if available

  // Get headers for API requests
  Future<Map<String, String>> getHeaders() async {
    // Ensure shrePref is initialized
    if (shrePref == null) {
      throw Exception("SharedPreferences has not been initialized.");
    }

    // Retrieve the token from SharedPreferences
    final token = shrePref?.getString("token") ?? "";

    // Return the headers with the token if available
    return {
      "Content-Type": "application/json",
      "Authorization": token.isNotEmpty ? "Bearer $token" : "",
    };
  }

  // HTTP GET request
  Future<http.Response> get(String endpoint) async {
    final uri = Uri.parse("$baseUrl$endpoint");
    final headers = await getHeaders();

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception('GET $endpoint failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during GET $endpoint: $e');
    }
  }

  // HTTP POST request
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse("$baseUrl$endpoint");
    final headers = await getHeaders();

    try {
      final response = await http.post(uri, headers: headers, body: json.encode(body));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception('POST $endpoint failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error during POST $endpoint: $e');
    }
  }
}
