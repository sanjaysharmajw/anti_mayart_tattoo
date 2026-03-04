import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/about.dart';

class AboutProvider with ChangeNotifier {
  List<About> _abouts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<About> get abouts => _abouts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String baseUrl = "https://anti-mayart-tattoo.onrender.com/api";

  Future<void> fetchAbout() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(Uri.parse('$baseUrl/getAbout'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        _abouts = data.map((e) => About.fromJson(e)).toList();
      } else {
        _errorMessage = 'Failed to load about details';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAbout(String title, String description) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createAbout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'description': description}),
      );
      if (response.statusCode == 201) {
        fetchAbout();
        return true;
      }
      _errorMessage = 'Failed to create about';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateAbout(String id, String title, String description) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateAbout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'title': title, 'description': description}),
      );
      if (response.statusCode == 200) {
        fetchAbout();
        return true;
      }
      _errorMessage = 'Failed to update about';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAbout(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteAbout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      if (response.statusCode == 200) {
        _abouts.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      _errorMessage = 'Failed to delete about';
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
