import 'package:flutter/material.dart';

import 'config/firebase_config.dart';
import 'models/user_profile.dart';
import 'screens/auth_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/launch_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/setup/setup_flow_navigator.dart';
import 'screens/setup/setup_models.dart';
import 'services/auth_service.dart';
import 'services/profile_api.dart';

Future<void> main() async {
  // Flutter must initialise its engine before we can call Firebase plugins.
  WidgetsFlutterBinding.ensureInitialized();
  // Reads the local Firebase config and connects the app to Firebase.
  await FirebaseBootstrap.initialize();
  // Starts the widget tree. Everything visible in the app is below this widget.
  runApp(const MoveWellApp());
}

class MoveWellApp extends StatelessWidget {
  const MoveWellApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MoveWell',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'Arial',
      scaffoldBackgroundColor: const Color(0xFFF7FAFD),
    ),
    home: const OnboardingFlow(),
  );
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  // A small state machine controls the launch → auth → setup → home journey.
  // 0: launch, 1: welcome, 2: auth, 3: setup, 4: password reset, 5: home.
  int _page = 0;
  // Prevents duplicate network requests when a user taps a button repeatedly.
  bool _working = false;

  void _go(int page) => setState(() => _page = page.clamp(0, 5));

  Future<void> _continueFromSession() async {
    // Returning users may already have a Firebase session stored on the device.
    if (AuthService.instance.currentUser == null) {
      _go(2);
      return;
    }
    try {
      await _finishAuthentication();
    } catch (error) {
      if (!mounted) return;
      _go(5);
    }
  }

  Future<void> _finishAuthentication() async {
    if (_working) return;
    setState(() => _working = true);
    try {
      // The backend creates a Firestore profile if this is the user's first login.
      UserProfile profile;
      try {
        profile = await ProfileApi.instance.syncUser();
      } catch (_) {
        // Standalone fallback: if backend API is offline, create profile from Firebase auth
        final firebaseUser = AuthService.instance.currentUser;
        profile = UserProfile(
          email: firebaseUser?.email ?? '',
          fullName: firebaseUser?.displayName?.isNotEmpty == true
              ? firebaseUser!.displayName!
              : 'MoveWell Member',
          onboardingComplete: true,
        );
      }
      UserProfileNotifier.instance.updateProfile(profile);
      // New users must fill in their fitness profile; returning users go home.
      _go(profile.onboardingComplete ? 5 : 3);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _completeSetup(SetupProfileData data) async {
    if (_working) return;
    setState(() => _working = true);
    try {
      final firebaseUser = AuthService.instance.currentUser;
      final current = UserProfileNotifier.instance.profile;
      // Keep existing settings, while replacing the fields supplied in setup.
      final profile = current.copyWith(
        fullName: data.fullName,
        email: firebaseUser?.email ?? current.email,
        avatarPath: firebaseUser?.photoURL?.isNotEmpty == true
            ? firebaseUser!.photoURL
            : current.avatarPath,
        dateOfBirth: data.dateOfBirth,
        gender: data.gender,
        height: data.height,
        heightUnit: data.heightUnit,
        weight: data.weight,
        weightUnit: data.weightUnit,
        age: data.age,
        activityLevel: data.activityLevel,
        goal: data.goal,
        onboardingComplete: true,
      );
      // Persist the completed profile through the backend API if available.
      UserProfile saved;
      try {
        saved = await ProfileApi.instance.saveProfile(profile);
      } catch (_) {
        saved = profile;
      }
      UserProfileNotifier.instance.updateProfile(saved);
      _go(5);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save your profile: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Select exactly one screen for the current point in the app flow.
    Widget currentWidget;
    switch (_page) {
      case 0:
        currentWidget = LaunchScreen(onDone: () => _go(1));
        break;
      case 1:
        currentWidget = OnboardingScreen(onGetStarted: _continueFromSession);
        break;
      case 2:
        currentWidget = AuthScreen(
          onAuthenticated: _finishAuthentication,
          onForgot: () => _go(4),
        );
        break;
      case 3:
        currentWidget = SetupFlowNavigator(
          initialName: AuthService.instance.currentUser?.displayName,
          onFinish: _completeSetup,
          onExitToAuth: () => _go(2),
        );
        break;
      case 4:
        currentWidget = ForgotPasswordScreen(onBack: () => _go(2));
        break;
      case 5:
      default:
        currentWidget = HomeScreen(onLogout: () => _go(2));
        break;
    }

    return Scaffold(
      // Gives page changes a gentle transition without adding a routing package.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        child: KeyedSubtree(key: ValueKey(_page), child: currentWidget),
      ),
    );
  }
}
