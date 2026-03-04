import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

    final String baseUrl = "https://anti-mayart-tattoo.onrender.com/api";

  // final String baseUrl = "http://localhost:5000/api";

  Future<void> fetchContacts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(Uri.parse('$baseUrl/getContacts'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        _contacts = data.map((e) => Contact.fromJson(e)).toList();
      } else {
        _errorMessage = 'Failed to load contacts';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createContact(String fullName, String email, String phoneNumber, String message) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createContact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName, 
          'email': email,
          'phoneNumber': phoneNumber,
          'message': message,
        }),
      );
      if (response.statusCode == 201) {
        fetchContacts();
        return true;
      }
      _errorMessage = 'Failed to create contact';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteContact(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteContact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      if (response.statusCode == 200) {
        _contacts.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      _errorMessage = 'Failed to delete contact';
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
