import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // For web (Edge)
    } else {
      return 'http://192.168.43.70:3000'; // For mobile (replace with your actual IP)
    }
  }

  // Error handling wrapper
  static Future<http.Response> _handleRequest(
    Future<http.Response> request,
  ) async {
    try {
      final response = await request;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        _showToast('Server error: ${response.statusCode}');
        throw Exception('HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _showToast('Connection failed: Check your internet');
      rethrow;
    }
  }

  // Get all users
  static Future<List<dynamic>> getData() async {
    final response = await _handleRequest(
      http.get(Uri.parse('$baseUrl/users')),
    );
    return jsonDecode(response.body)['data'];
  }

  // Create user
  static Future<void> addData(String name, String email) async {
    await _handleRequest(
      http.post(
        Uri.parse('$baseUrl/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      ),
    );
  }

  // Toast helper
  static void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
