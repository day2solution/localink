import 'dart:async'; // <--- Add this for TimeoutException
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localink/marketplace/promo.dart';
import 'package:localink/model/api_response.dart';
import 'package:localink/model/auth_response.dart';
import 'package:localink/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class ApiService {
  static const String baseUrl = "http://192.168.0.133:8010/api/v1";
  final Logger _log = Logger('ApiService');
  static const Duration _timeoutDuration = Duration(seconds: 10);

  Future<List<dynamic>> fetchMarketplaceItems(String category) async {
    try {
      final queryParam = category == "All Items" ? "" : "?category=$category";
      _log.info("Fetching products for category: $category");
      final url = Uri.parse("$baseUrl/marketplace/items");

      final response = await http.get(url, headers: await _getHeaders(requiresAuth: true))
          .timeout(_timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      _log.severe("Connection timed out");
      throw Exception(
        "The server is taking too long to respond. Please try again.",
      );
    } on SocketException {
      _log.severe("No Internet Connection");
      throw Exception("Please check your internet connection.");
    } catch (e) {
      _log.severe("Error fetching products: $e");
      rethrow;
    }
  }

  // --- 2. CREATE POST ---
  Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      final url = Uri.parse("$baseUrl/marketplace/create");
      final response = await http
          .post(
            url,
            headers: await _getHeaders(requiresAuth: true),
            body: jsonEncode(productData),
          )
          .timeout(_timeoutDuration); // <--- Set timeout here

      _handleResponse(response);
      _log.info("Product created successfully");
    } on TimeoutException {
      throw Exception("Failed to send data. Connection timed out.");
    } catch (e) {
      _log.severe("Failed to create product: $e");
      rethrow;
    }
  }
  Future<List<Promo>> fetchPromos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/marketplace/promo'),
      headers: await _getHeaders(requiresAuth: true),
    );

    final dynamic decodedData = _handleResponse(response);

    if (decodedData is List) {
      return decodedData.map((json) {
        // Use your existing helpers to get Icon and Colors
        final icon = _getIconData(json['tag']?.toString() ?? "");
        final colors = _getRandomGradient();

        return Promo.fromJson(json, icon, colors);
      }).toList();
    } else {
      return [];
    }
  }
  // Helper to provide random beautiful gradients for Promos
  List<Color> _getRandomGradient() {
    final List<List<Color>> gradients = [
      [const Color(0xFF2563EB), const Color(0xFF7C3AED)], // Blue to Purple
      [const Color(0xFFF59E0B), const Color(0xFFEF4444)], // Orange to Red
      [const Color(0xFF10B981), const Color(0xFF3B82F6)], // Emerald to Blue
      [const Color(0xFFEC4899), const Color(0xFF8B5CF6)], // Pink to Violet
      [const Color(0xFF06B6D4), const Color(0xFF3B82F6)], // Cyan to Blue
    ];

    // Pick a random index from the list
    return (gradients..shuffle()).first;
  }
  IconData _getIconData(String name) {
    _log.info("Received icon name: $name");
    switch (name.toLowerCase()) {
      case 'celebration': return Icons.celebration_rounded;
      case 'shield': return Icons.shield_rounded;
      case 'shopping': return Icons.shopping_bag_rounded;
      default: return Icons.info_outline;
    }
  }
  // --- 3. LOGIN WITH MOBILE ---
  Future<AuthResponse> loginWithMobile(Map<String, dynamic> login_data) async {
    try {
      _log.info("login_data: $login_data");
      final url = Uri.parse("$baseUrl/auth/login-mobile");
      final response = await http
          .post(
            url,
            headers: await _getHeaders(),
            body: jsonEncode(login_data),
          )
          .timeout(_timeoutDuration);

      final dynamic data = _handleResponse(response);
      final AuthResponse authResponse = AuthResponse.fromJson(data);

      _log.info("Login successful for mobile: ${authResponse.mobileNumber}");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authResponse.accessToken);
      return authResponse;
    } on TimeoutException {
      throw Exception("Login service timed out.");
    } catch (e) {
      _log.severe("Login failed: $e");
      rethrow;
    }
  }
  Future<AuthResponse> signupWithMobile(Map<String, dynamic> login_data) async {
    try {
      final url = Uri.parse("$baseUrl/auth/signup-mobile");
      final response = await http
          .post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(login_data),
      )
          .timeout(_timeoutDuration);

      final dynamic data = _handleResponse(response);
      final AuthResponse authResponse = AuthResponse.fromJson(data);

      _log.info("Login successful for mobile: ${authResponse.mobileNumber}");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', authResponse.accessToken);
      return authResponse;
    } on TimeoutException {
      throw Exception("Login service timed out.");
    } catch (e) {
      _log.severe("Login failed: $e");
      rethrow;
    }
  }


  // --- 4. FETCH USER BY MOBILE ---
  Future<User> fetchUserByMobile(String mobileNumber) async {
    try {
      final url = Uri.parse("$baseUrl/users/$mobileNumber");
      _log.info("Fetching user profile for: $mobileNumber");
      final response = await http
          .get(url, headers: await _getHeaders(requiresAuth: true))
          .timeout(_timeoutDuration);

      final Map<String, dynamic> jsonMap = _handleResponse(response);

      // Wrap with your Generic ApiResponse
      final apiResponse = ApiResponse<User>.fromJson(
        jsonMap,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == "success" && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.description ?? "User not found");
      }
    } on TimeoutException {
      throw Exception("Connection timed out while fetching user profile.");
    } catch (e) {
      _log.severe("Error fetching user: $e");
      rethrow;
    }
  }

  // --- 5. UPDATE USER PROFILE ---
  Future<User> updateUserProfile(Map<String, dynamic> userData) async {
    try {
      final url = Uri.parse("$baseUrl/users/update/${userData['mobileNumber']}");
      _log.info("Updating user profile with data: $userData");

      final response = await http
          .put(
            url,
            headers: await _getHeaders(requiresAuth: true),
            body: jsonEncode(userData),
          )
          .timeout(_timeoutDuration);

      final Map<String, dynamic> jsonMap = _handleResponse(response);

      final apiResponse = ApiResponse<User>.fromJson(
        jsonMap,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.status == "success" && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.description ?? "Failed to update profile");
      }
    } on TimeoutException {
      throw Exception("Connection timed out while updating profile.");
    } catch (e) {
      _log.severe("Error updating profile: $e");
      rethrow;
    }
  }

  // --- 6. UPLOAD PROFILE PICTURE ---
  Future<String> uploadProfilePicture(String mobileNumber, File imageFile) async {
    try {
      final url = Uri.parse("$baseUrl/users/$mobileNumber/profile-picture");
      _log.info("Uploading profile picture for: $mobileNumber");

      var request = http.MultipartRequest('POST', url);

      // Add Headers
      request.headers.addAll(await _getHeaders(requiresAuth: true));

      // Add File
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      final streamedResponse = await request.send().timeout(_timeoutDuration);
      final response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> jsonMap = _handleResponse(response);

      final apiResponse = ApiResponse<String>.fromJson(
        jsonMap,
        (data) => data.toString(),
      );

      if (apiResponse.status == "success" && apiResponse.data != null) {
        return apiResponse.data!; // Returns the new image URL
      } else {
        throw Exception(apiResponse.description ?? "Failed to upload image");
      }
    } on TimeoutException {
      throw Exception("Connection timed out while uploading image.");
    } catch (e) {
      _log.severe("Error uploading image: $e");
      rethrow;
    }
  }

  // --- 7. GET MOBILE FROM TOKEN ---
  Future<String> getMobileFromToken() async {
    try {
      final url = Uri.parse("$baseUrl/users/mobile");

      _log.info("Fetching mobile number from token");

      final response = await http
          .get(url, headers: await _getHeaders(requiresAuth: true))
          .timeout(_timeoutDuration);

      final Map<String, dynamic> jsonMap = _handleResponse(response);

      // 1. Correct the Generic type to String
      // 2. Since the data is a simple String, the converter just returns the data as a String
      final apiResponse = ApiResponse<String>.fromJson(jsonMap, (data) => data.toString(),);

      if (apiResponse.status == "success" && apiResponse.data != null) {
        return apiResponse.data!; // Returns the mobile number string
      } else {
        throw Exception(
          apiResponse.description ?? "Failed to extract mobile number",
        );
      }
    } on TimeoutException {
      throw Exception("Connection timed out while verifying token.");
    } catch (e) {
      _log.severe("Error fetching mobile from token: $e");
      rethrow;
    }
  }

  // --- CENTRALIZED ERROR HANDLING ---
  dynamic _handleResponse(http.Response response) {
    _log.info("Response Request: ${response.request}");
    _log.info("Response Headers: ${response.headers}");
    _log.severe("Response Status: ${response.statusCode}");
    _log.info("Response Body: ${response.body}");



    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 401:
        throw Exception("Unauthorized: Please login again.");
      case 403:
        throw Exception("Access Denied: You do not have permission.");
      case 500:
        throw Exception("Server Error: Please try again later.");
      default:
        throw Exception("Unexpected Error: ${response.statusCode}");
    }
  }

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }
    _log.info("Headers: $headers");
    return headers;
  }
}
