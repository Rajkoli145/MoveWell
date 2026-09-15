import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/firebase_config.dart';
import 'profile_api.dart';

class WeeklyChallenge {
  // This model mirrors one challenge object returned by the backend.
  const WeeklyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.goal,
  });
  final String id, title, description, icon;
  final int progress, goal;
  bool get isComplete => progress >= goal;
  factory WeeklyChallenge.fromJson(Map<String, dynamic> json) =>
      WeeklyChallenge(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String,
        progress: (json['progress'] as num).round(),
        goal: (json['goal'] as num).round(),
      );
}

class ActivitySummary {
  // Dashboard data is kept together so screens can refresh it in one request.
  const ActivitySummary({required this.waterGlasses, required this.challenges});
  final int waterGlasses;
  final List<WeeklyChallenge> challenges;
  factory ActivitySummary.fromJson(Map<String, dynamic> json) =>
      ActivitySummary(
        waterGlasses: (json['waterGlasses'] as num? ?? 0).round(),
        challenges: (json['challenges'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()
            .map(WeeklyChallenge.fromJson)
            .toList(),
      );
}

class ActivityApi {
  ActivityApi._({http.Client? client}) : _client = client ?? http.Client();
  static final instance = ActivityApi._();
  final http.Client _client;
  // The backend stores daily activity by YYYY-MM-DD in the user's local day.
  String _date() => DateTime.now().toIso8601String().substring(0, 10);

  Future<ActivitySummary> dashboard() async {
    // Load today's water log and this week's challenge progress together.
    final response = await _client.get(
      Uri.parse(
        '${FirebaseConfig.backendBaseUrl}/api/dashboard?date=${_date()}',
      ),
      headers: await ProfileApi.instance.authHeaders(),
    );
    return _summary(response);
  }

  Future<ActivitySummary> setWater(int glasses) async {
    // Saving water may also complete or remove today's hydration challenge day.
    final response = await _client.put(
      Uri.parse('${FirebaseConfig.backendBaseUrl}/api/daily-water'),
      headers: await ProfileApi.instance.authHeaders(),
      body: jsonEncode({'glasses': glasses, 'localDate': _date()}),
    );
    return _summary(response);
  }

  Future<ActivitySummary> recordWorkout({
    required String title,
    required String? routineId,
    required int durationMinutes,
    required List<String> exercises,
  }) async {
    final now = DateTime.now();
    // A completed workout is the event that advances Move 5 Days and, before
    // noon, Morning Momentum. The Firebase token is added by authHeaders().
    final response = await _client.post(
      Uri.parse('${FirebaseConfig.backendBaseUrl}/api/workout-sessions'),
      headers: await ProfileApi.instance.authHeaders(),
      body: jsonEncode({
        'workoutTitle': title,
        'routineId': routineId,
        'durationMinutes': durationMinutes,
        'exerciseCount': exercises.length,
        'exercises': exercises,
        'localDate': _date(),
        'completedInMorning': now.hour < 12,
      }),
    );
    return _summary(response);
  }

  ActivitySummary _summary(http.Response response) {
    // Turn unsuccessful HTTP responses into a readable app exception.
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProfileApiException(
        body['error'] as String? ?? 'Could not save activity.',
        response.statusCode,
      );
    }
    return ActivitySummary.fromJson(body['data'] as Map<String, dynamic>);
  }
}
