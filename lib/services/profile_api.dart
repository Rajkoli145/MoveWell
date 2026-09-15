import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../config/firebase_config.dart';
import '../models/user_profile.dart';
import 'auth_service.dart';

class ProfileApiException implements Exception {
  const ProfileApiException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ProfileApi {
  // One shared API client is enough for profile requests in the whole app.
  ProfileApi._({http.Client? client}) : _client = client ?? http.Client();

  static final instance = ProfileApi._();
  final http.Client _client;

  Future<Map<String, String>> authHeaders() async {
    // Backends do not trust a user ID supplied by the app. They verify this
    // short-lived Firebase ID token instead.
    final User? user = AuthService.instance.currentUser;
    if (user == null) {
      throw const ProfileApiException('Please sign in first.', 401);
    }
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw const ProfileApiException(
        'Could not create a Firebase ID token.',
        401,
      );
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Keeps every request pointed at the backend configured for this build.
  Uri _uri(String path) => Uri.parse('${FirebaseConfig.backendBaseUrl}$path');

  Future<UserProfile> syncUser() async {
    // Called immediately after login to create the profile document if needed.
    final response = await _client.post(
      _uri('/api/users/sync'),
      headers: await authHeaders(),
    );
    return _profileFromResponse(response);
  }

  Future<UserProfile> getProfile() async {
    final response = await _client.get(
      _uri('/api/profile'),
      headers: await authHeaders(),
    );
    return _profileFromResponse(response);
  }

  Future<UserProfile> saveProfile(UserProfile profile) async {
    final response = await _client.put(
      _uri('/api/profile'),
      headers: await authHeaders(),
      body: jsonEncode(profile.toJson()),
    );
    return _profileFromResponse(response);
  }

  UserProfile _profileFromResponse(http.Response response) {
    // APIs return JSON. Decode it once and centralise status-code handling.
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ProfileApiException(
        'The backend returned an invalid response.',
        response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProfileApiException(
        body['error'] as String? ?? 'Backend request failed.',
        response.statusCode,
      );
    }
    return UserProfile.fromJson(body['data'] as Map<String, dynamic>);
  }
}
