import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/launch_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/setup/setup_flow_navigator.dart';

void main() => runApp(const MoveWellApp());

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
  int _page = 0;

  void _go(int page) => setState(() => _page = page.clamp(0, 5));

  @override
  Widget build(BuildContext context) {
    Widget currentWidget;
    switch (_page) {
      case 0:
        currentWidget = LaunchScreen(onDone: () => _go(1));
        break;
      case 1:
        currentWidget = OnboardingScreen(onGetStarted: () => _go(2));
        break;
      case 2:
        currentWidget = AuthScreen(
          onContinue: () => _go(3),
          onForgot: () => _go(4),
        );
        break;
      case 3:
        currentWidget = SetupFlowNavigator(
          onFinish: () => _go(5),
          onExitToAuth: () => _go(2),
        );
        break;
      case 4:
        currentWidget = ForgotPasswordScreen(onBack: () => _go(2));
        break;
      case 5:
      default:
        currentWidget = HomeScreen(
          onStartWorkout: () {},
          onViewAllRecommended: () {},
          onViewAllChallenges: () {},
          onViewAllArticles: () {},
        );
        break;
    }

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        child: KeyedSubtree(
          key: ValueKey(_page),
          child: currentWidget,
        ),
      ),
    );
  }
}
