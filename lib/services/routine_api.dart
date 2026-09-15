import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/firebase_config.dart';
import 'profile_api.dart';

class Routine {
  /// A routine saved under the signed-in user's Firestore account.
  const Routine({
    required this.id,
    required this.title,
    required this.level,
    required this.durationMinutes,
    required this.exercises,
    required this.favorite,
  });

  final String id;
  final String title;
  final String level;
  final int durationMinutes;
  final List<String> exercises;
  final bool favorite;

  factory Routine.fromJson(Map<String, dynamic> json) => Routine(
    id: json['id'] as String,
    title: json['title'] as String,
    level: json['level'] as String,
    durationMinutes: (json['durationMinutes'] as num).round(),
    exercises: (json['exercises'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(),
    favorite: json['favorite'] as bool? ?? false,
  );

  /// Creates an updated immutable copy after a favourite toggle.
  Routine copyWith({bool? favorite}) => Routine(
    id: id,
    title: title,
    level: level,
    durationMinutes: durationMinutes,
    exercises: exercises,
    favorite: favorite ?? this.favorite,
  );
}

class RoutineApi {
  // This service is responsible only for saved custom routines.
  RoutineApi._({http.Client? client}) : _client = client ?? http.Client();

  static final instance = RoutineApi._();
  final http.Client _client;

  Future<List<Routine>> list() async {
    // The backend scopes results to the Firebase token's user ID.
    final response = await _client.get(
      Uri.parse('${FirebaseConfig.backendBaseUrl}/api/routines'),
      headers: await ProfileApi.instance.authHeaders(),
    );
    final body = _body(response);
    return (body['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Routine.fromJson)
        .toList();
  }

  Future<Routine> create({
    required String title,
    required String level,
    required int durationMinutes,
    List<String> exercises = const [],
  }) async {
    // Send only serialisable fields; timestamps and IDs are generated server-side.
    final response = await _client.post(
      Uri.parse('${FirebaseConfig.backendBaseUrl}/api/routines'),
      headers: await ProfileApi.instance.authHeaders(),
      body: jsonEncode({
        'title': title.trim(),
        'level': level,
        'durationMinutes': durationMinutes,
        'exercises': exercises,
      }),
    );
    return Routine.fromJson(_body(response)['data'] as Map<String, dynamic>);
  }

  Future<Routine> setFavorite(Routine routine, bool favorite) async {
    // PATCH changes just the favourite value rather than replacing a routine.
    final response = await _client.patch(
      Uri.parse(
        '${FirebaseConfig.backendBaseUrl}/api/routines/${routine.id}/favorite',
      ),
      headers: await ProfileApi.instance.authHeaders(),
      body: jsonEncode({'favorite': favorite}),
    );
    return Routine.fromJson(_body(response)['data'] as Map<String, dynamic>);
  }

  Map<String, dynamic> _body(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ProfileApiException(
        body['error'] as String? ?? 'Routine request failed.',
        response.statusCode,
      );
    }
    return body;
  }
}
