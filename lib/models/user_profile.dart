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
  });

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
    );
    notifyListeners();
  }
}
