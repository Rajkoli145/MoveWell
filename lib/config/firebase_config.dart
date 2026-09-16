import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration supplied at build time, keeping project credentials
/// and environment-specific identifiers out of source control.
abstract final class FirebaseConfig {
  // Values come from --dart-define or --dart-define-from-file=config/firebase.local.json at run time.
  static const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const _rawAppId = String.fromEnvironment('FIREBASE_APP_ID');

  static String get appId {
    if (_rawAppId.isNotEmpty) return _rawAppId;
    if (kIsWeb) return const String.fromEnvironment('FIREBASE_WEB_APP_ID');
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return const String.fromEnvironment('FIREBASE_IOS_APP_ID');
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const String.fromEnvironment('FIREBASE_ANDROID_APP_ID');
    }
    return const String.fromEnvironment('FIREBASE_WEB_APP_ID');
  }

  static const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');
  static const iosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  static bool get isConfigured =>
      apiKey.isNotEmpty &&
      appId.isNotEmpty &&
      messagingSenderId.isNotEmpty &&
      projectId.isNotEmpty;

  static FirebaseOptions get options => FirebaseOptions(
    // Firebase.initializeApp consumes these values to identify this app.
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: authDomain.isEmpty ? null : authDomain,
    storageBucket: storageBucket.isEmpty ? null : storageBucket,
    iosBundleId: iosBundleId.isEmpty ? null : iosBundleId,
    iosClientId: iosClientId.isEmpty ? null : iosClientId,
  );

  static String get backendBaseUrl {
    // Local web, Android emulators, and physical devices each reach localhost
    // differently. BACKEND_URL overrides these development defaults.
    const configured = String.fromEnvironment('BACKEND_URL');
    if (configured.isNotEmpty) return configured.replaceAll(RegExp(r'/$'), '');
    if (kIsWeb) return 'http://localhost:8080';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://127.0.0.1:8080';
  }
}

abstract final class FirebaseBootstrap {
  static bool isReady = false;
  static Object? error;

  static Future<void> initialize() async {
    // 1. Attempt native initialization first (iOS/macOS GoogleService-Info.plist or Android google-services.json)
    if (!kIsWeb) {
      try {
        await Firebase.initializeApp();
        isReady = true;
        return;
      } catch (_) {
        // Fall back to dart-define configuration below
      }
    }

    // 2. Fall back to manual options if provided via --dart-define or --dart-define-from-file
    if (FirebaseConfig.isConfigured) {
      try {
        await Firebase.initializeApp(options: FirebaseConfig.options);
        isReady = true;
        return;
      } catch (firebaseError) {
        error = firebaseError;
        return;
      }
    }

    // 3. Do not crash the launch screen when local config is not provided
    error = StateError(
      'Firebase build-time values are missing. See README.md for setup.',
    );
  }
}
