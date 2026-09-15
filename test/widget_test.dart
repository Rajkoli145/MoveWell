import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movewell/main.dart';
import 'package:movewell/palette.dart';
import 'package:movewell/screens/auth_screen.dart';
import 'package:movewell/screens/edit_profile_screen.dart';
import 'package:movewell/screens/forgot_password_screen.dart';
import 'package:movewell/screens/home_screen.dart';
import 'package:movewell/screens/notification_screen.dart';
import 'package:movewell/screens/profile_view_screen.dart';
import 'package:movewell/screens/settings_screen.dart';
import 'package:movewell/screens/setup/setup_flow_navigator.dart';

void main() {
  testWidgets('MoveWell renders the launch experience', (tester) async {
    await tester.pumpWidget(const MoveWellApp());
    expect(find.byType(MoveWellApp), findsOneWidget);
  });

  testWidgets('SlideActionPillButton does not trigger on quick tap, but triggers on drag', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              child: SlideActionPillButton(
                label: 'Slide to Continue',
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Slide to Continue'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);

    // 1. Quick tap should NOT trigger
    await tester.tap(find.byType(SlideActionPillButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tapped, isFalse);

    // 2. Drag left to right triggers completion
    await tester.drag(find.byType(SlideActionPillButton), const Offset(260, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 300));

    expect(tapped, isTrue);
  });

  testWidgets('SlideActionPillButton auto-drags and completes on hold', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              child: SlideActionPillButton(
                label: 'Hold to Continue',
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      ),
    );

    // Start pressing down (hold)
    final gesture = await tester.startGesture(tester.getCenter(find.byType(SlideActionPillButton)));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tapped, isFalse); // halfway through hold

    // Wait until 700ms charge finishes + checkmark animation
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump(const Duration(milliseconds: 150));
    await gesture.up();
    await tester.pump(const Duration(milliseconds: 300));

    expect(tapped, isTrue);
  });

  testWidgets('AuthScreen renders properly with Log In SlideActionPillButton', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AuthScreen(
          onContinue: () {},
          onForgot: () {},
        ),
      ),
    );
    expect(find.text('Log In'), findsWidgets);
    expect(find.text('Sign Up'), findsWidgets);
    expect(find.byType(SlideActionPillButton), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen renders properly with all components', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ForgotPasswordScreen(onBack: () {}),
      ),
    );
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);
    expect(find.text('Back to Log In'), findsOneWidget);
  });

  testWidgets('SetupFlowNavigator renders Step 1 Gender Screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SetupFlowNavigator(
          onFinish: () {},
          onExitToAuth: () {},
        ),
      ),
    );
    expect(find.text('What’s your gender?'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('Prefer not to say'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('1/6', findRichText: true), findsOneWidget);
  });

  testWidgets('Setup flow navigates through steps with slide interactions', (tester) async {
    var finished = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 375,
              height: 812,
              child: SetupFlowNavigator(
                onFinish: () => finished = true,
                onExitToAuth: () {},
              ),
            ),
          ),
        ),
      ),
    );

    Future<void> slideStepButton(String text) async {
      expect(find.text(text), findsOneWidget);
      await tester.drag(find.byType(SlideActionPillButton), const Offset(260, 0));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
    }

    // Step 0: Gender -> Next
    await slideStepButton('Next');

    // Step 1: Age -> Next
    await slideStepButton('Next');

    // Step 2: Weight -> Next
    await slideStepButton('Next');

    // Step 3: Height -> Next
    await slideStepButton('Next');

    // Step 4: Goal -> Next
    await slideStepButton('Next');

    // Step 5: Physical Activity -> Next
    await slideStepButton('Next');

    // Step 6: Profile -> Complete Profile
    await slideStepButton('Complete Profile');

    // Step 7: Almost There -> Continue
    await slideStepButton('Continue');

    // Step 8: All Set -> Go to Dashboard
    await slideStepButton('Go to Dashboard');

    expect(finished, isTrue);
  });

  testWidgets('HomeScreen renders properly with all dashboard sections and navigation items', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(
          userName: 'Raj',
        ),
      ),
    );

    // 1. App Bar branding
    expect(find.text('MoveWell'), findsOneWidget);
    expect(find.text('A HEALTHIER YOU, EVERYDAY'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);

    // 2. Greeting & Motivation
    expect(find.text('Mon, 16 Sep'), findsOneWidget);
    expect(find.text('PROGRESS'), findsOneWidget);
    expect(find.text('LIVES HERE'), findsOneWidget);
    expect(find.text('Small steps today\nlead to big results.'), findsOneWidget);

    // 3. Metrics
    expect(find.text('4320'), findsOneWidget);
    expect(find.text('Steps'), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    expect(find.text('Workout'), findsOneWidget);

    // 4. Recommended Workout
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text("Today's Workout"), findsOneWidget);
    expect(find.text('Full Body Strength'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);

    // 5. Weekly Challenge
    expect(find.text('Weekly Challenge'), findsOneWidget);
    expect(find.text('Move 5 Days This Week'), findsOneWidget);
    expect(find.text('2 / 5'), findsOneWidget);

    // 6. Articles & Tips
    expect(find.text('Articles & Tips'), findsOneWidget);
    expect(find.text('5 Simple Nutrition\nTips for Better Energy'), findsOneWidget);

    // 7. Navigation Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Resources'), findsOneWidget);
    expect(find.text('Favorite'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
  });

  testWidgets('ProfileViewScreen renders properly with all profile sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProfileViewScreen(),
      ),
    );

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Raj Koli'), findsOneWidget);
    expect(find.text('Stay consistent, stay better.'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    expect(find.text('Activity Level'), findsOneWidget);

    expect(find.text('View Your Progress'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Current Goal'), findsOneWidget);
    expect(find.text('Build Strength'), findsOneWidget);

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Privacy & Security'), findsOneWidget);
    expect(find.text('App Settings'), findsOneWidget);

    expect(find.text('Help Center'), findsOneWidget);
    expect(find.text('Online Support'), findsOneWidget);
    expect(find.text('About MoveWell'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('EditProfileScreen renders properly and supports editing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: EditProfileScreen(),
      ),
    );

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Keep your information up to date\nfor a better experience.'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('Activity Level'), findsOneWidget);

    expect(find.text('Fitness Goals'), findsOneWidget);
    expect(find.text('Your Goal'), findsOneWidget);

    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
  });

  testWidgets('NotificationScreen renders filters and notification sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: NotificationScreen(),
      ),
    );

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Mark all as read'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Workouts'), findsOneWidget);
    expect(find.text('Nutrition'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Time for your workout!'), findsOneWidget);
    expect(find.text("You're on a streak!"), findsOneWidget);
    expect(find.text('Great progress!'), findsOneWidget);

    expect(find.text('This Week'), findsOneWidget);
    expect(find.text('New article for you'), findsOneWidget);
    expect(find.text('Community challenge'), findsOneWidget);
    expect(find.text('Weekly report is ready'), findsOneWidget);

    expect(find.text('Earlier'), findsOneWidget);
    expect(find.text('Welcome to MoveWell!'), findsOneWidget);
    expect(find.text('Profile updated'), findsOneWidget);

    // Tap Mark all as read
    await tester.tap(find.text('Mark all as read'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('All notifications marked as read'), findsOneWidget);
  });

  testWidgets('SettingsScreen renders all settings categories and options', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsScreen(),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Customize your experience\nand make MoveWell yours.'), findsOneWidget);

    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Font Size'), findsOneWidget);

    expect(find.text('App Preferences'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Units'), findsOneWidget);

    expect(find.text('Data & Privacy'), findsOneWidget);
    expect(find.text('Privacy & Security'), findsOneWidget);
    expect(find.text('Download My Data'), findsOneWidget);
    expect(find.text('Delete Account'), findsOneWidget);

    expect(find.text('About'), findsOneWidget);
    expect(find.text('About MoveWell'), findsOneWidget);
    expect(find.text('Terms of Service'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);

    expect(find.text('Log Out'), findsOneWidget);
  });
}







