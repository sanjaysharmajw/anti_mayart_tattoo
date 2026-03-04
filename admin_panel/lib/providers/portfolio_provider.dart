import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/portfolio.dart';

class PortfolioProvider with ChangeNotifier {
  List<Portfolio> _portfolios = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Portfolio> get portfolios => _portfolios;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String baseUrl = "https://anti-mayart-tattoo.onrender.com/api";

  Future<void> fetchPortfolio() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(Uri.parse('$baseUrl/getPortfolio'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        _portfolios = data.map((e) => Portfolio.fromJson(e)).toList();
      } else {
        _errorMessage = 'Failed to load portfolio details';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPortfolio(String title, Uint8List imageBytes, String filename) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/createPortfolio'));
      request.fields['title'] = title;
      
      var multipartFile = http.MultipartFile.fromBytes(
        'image', 
        imageBytes, 
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 201) {
        fetchPortfolio();
        return true;
      }
      _errorMessage = 'Failed to create portfolio';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updatePortfolio(String id, String title, {Uint8List? imageBytes, String? filename}) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/updatePortfolio'));
      request.fields['id'] = id;
      request.fields['title'] = title;

      if (imageBytes != null && filename != null) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image', 
          imageBytes, 
          filename: filename,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        fetchPortfolio();
        return true;
      }
      _errorMessage = 'Failed to update portfolio';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deletePortfolio(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deletePortfolio'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      if (response.statusCode == 200) {
        _portfolios.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      _errorMessage = 'Failed to delete portfolio';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
