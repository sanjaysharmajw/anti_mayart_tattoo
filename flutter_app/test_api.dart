import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = "https://anti-mayart-tattoo.onrender.com/api";
  try {
    final response = await http.post(Uri.parse('$baseUrl/getPortfolio'));
    print('Portfolio Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      print('Portfolio data: $data');
    }
  } catch (e) {
    print('Portfolio error: $e');
  }

  try {
    final response = await http.post(Uri.parse('$baseUrl/getTattoo'));
    print('Tattoo Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      print('Tattoo data: $data');
    }
  } catch (e) {
    print('Tattoo error: $e');
  }
}
