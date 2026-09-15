import 'package:flutter/foundation.dart';

import '../palette.dart';

class UserProfile {
  String fullName;
  String email;
  String subtitle;
  String avatarPath;
  String dateOfBirth;
  String gender;
  int height;
  String heightUnit;
  double weight;
  String weightUnit;
  int age;
  String activityLevel;
  String goal;
  String language;
  String theme;
  bool notificationsEnabled;
  bool onboardingComplete;

  UserProfile({
    this.fullName = 'Raj Koli',
    this.email = 'rajkoli@example.com',
    this.subtitle = 'Stay consistent, stay better.',
    this.avatarPath = AppAssets.avatar,
    this.dateOfBirth = '12 Jun 2000',
    this.gender = 'Male',
    this.height = 172,
    this.heightUnit = 'cm',
    this.weight = 60.0,
    this.weightUnit = 'kg',
    this.age = 25,
    this.activityLevel = 'Moderately Active',
    this.goal = 'Build Strength',
    this.language = 'English',
    this.theme = 'Light',
    this.notificationsEnabled = true,
    this.onboardingComplete = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final remoteAvatar = json['avatarPath'] as String?;
    return UserProfile(
      fullName: json['fullName'] as String? ?? 'MoveWell User',
      email: json['email'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? 'Stay consistent, stay better.',
      avatarPath: remoteAvatar?.isNotEmpty == true
          ? remoteAvatar!
          : AppAssets.avatar,
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      height: (json['height'] as num?)?.round() ?? 172,
      heightUnit: json['heightUnit'] as String? ?? 'cm',
      weight: (json['weight'] as num?)?.toDouble() ?? 60,
      weightUnit: json['weightUnit'] as String? ?? 'kg',
      age: (json['age'] as num?)?.round() ?? 25,
      activityLevel: json['activityLevel'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
      language: json['language'] as String? ?? 'English',
      theme: json['theme'] as String? ?? 'Light',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'subtitle': subtitle,
    'avatarPath': avatarPath,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'height': height,
    'heightUnit': heightUnit,
    'weight': weight,
    'weightUnit': weightUnit,
    'age': age,
    'activityLevel': activityLevel,
    'goal': goal,
    'language': language,
    'theme': theme,
    'notificationsEnabled': notificationsEnabled,
    'onboardingComplete': onboardingComplete,
  };

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? subtitle,
    String? avatarPath,
    String? dateOfBirth,
    String? gender,
    int? height,
    String? heightUnit,
    double? weight,
    String? weightUnit,
    int? age,
    String? activityLevel,
    String? goal,
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      subtitle: subtitle ?? this.subtitle,
      avatarPath: avatarPath ?? this.avatarPath,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}

/// Global profile notifier for seamless updates across screens
class UserProfileNotifier extends ChangeNotifier {
  static final UserProfileNotifier instance = UserProfileNotifier._internal();

  UserProfileNotifier._internal();

  UserProfile _profile = UserProfile();

  UserProfile get profile => _profile;

  void updateProfile(UserProfile newProfile) {
    _profile = newProfile;
    notifyListeners();
  }

  void updateField({
    String? fullName,
    String? email,
    String? subtitle,
    String? avatarPath,
    String? dateOfBirth,
    String? gender,
    int? height,
    String? heightUnit,
    double? weight,
    String? weightUnit,
    int? age,
    String? activityLevel,
    String? goal,
    String? language,
    String? theme,
    bool? notificationsEnabled,
    bool? onboardingComplete,
  }) {
    _profile = _profile.copyWith(
      fullName: fullName,
      email: email,
      subtitle: subtitle,
      avatarPath: avatarPath,
      dateOfBirth: dateOfBirth,
      gender: gender,
      height: height,
      heightUnit: heightUnit,
      weight: weight,
      weightUnit: weightUnit,
      age: age,
      activityLevel: activityLevel,
      goal: goal,
      language: language,
      theme: theme,
      notificationsEnabled: notificationsEnabled,
      onboardingComplete: onboardingComplete,
    );
    notifyListeners();
  }
}
