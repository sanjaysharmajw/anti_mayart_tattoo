import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/tattoo.dart';

class TattooProvider with ChangeNotifier {
  List<Tattoo> _tattoos = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Tattoo> get tattoos => _tattoos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final String baseUrl = "https://anti-mayart-tattoo.onrender.com/api";

  Future<void> fetchTattoo() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(Uri.parse('$baseUrl/getTattoo'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        _tattoos = data.map((e) => Tattoo.fromJson(e)).toList();
      } else {
        _errorMessage = 'Failed to load tattoo details';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTattoo(String title, Uint8List imageBytes, String filename) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/createTattoo'));
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
        fetchTattoo();
        return true;
      }
      _errorMessage = 'Failed to create tattoo';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTattoo(String id, String title, {Uint8List? imageBytes, String? filename}) async {
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/updateTattoo'));
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
        fetchTattoo();
        return true;
      }
      _errorMessage = 'Failed to update tattoo';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTattoo(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteTattoo'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      if (response.statusCode == 200) {
        _tattoos.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      _errorMessage = 'Failed to delete tattoo';
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
