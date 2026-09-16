import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/firebase_config.dart';

class AuthService {
  // Private constructor + static instance makes this a single shared service.
  AuthService._();

  static final instance = AuthService._();

  FirebaseAuth get _auth {
    // Failing early produces a useful message if local Firebase config is missing.
    if (!FirebaseBootstrap.isReady) {
      throw StateError(
        'Firebase is not configured. Add the Firebase values described in README.md.',
      );
    }
    return FirebaseAuth.instance;
  }

  User? get currentUser => FirebaseBootstrap.isReady ? _auth.currentUser : null;

  Future<UserCredential> signInWithEmail(String email, String password) {
    // Firebase Auth owns password handling; this app never stores passwords.
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    // Firebase creates the account, then we attach the user's display name.
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(name.trim());
    await credential.user?.reload();
    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      // Browsers use Firebase's popup-based Google OAuth flow.
      return _auth.signInWithPopup(GoogleAuthProvider());
    }

    // Android/iOS use the native Google Sign-In plugin before exchanging
    // Google's ID token for a Firebase session.
    await GoogleSignIn.instance.initialize(
      clientId: FirebaseConfig.iosClientId.isEmpty
          ? null
          : FirebaseConfig.iosClientId,
      serverClientId: FirebaseConfig.googleServerClientId.isEmpty
          ? null
          : FirebaseConfig.googleServerClientId,
    );
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    // Sign out of Firebase and, on mobile, clear the native Google session too.
    await _auth.signOut();
    if (!kIsWeb) await GoogleSignIn.instance.signOut();
  }

  String readableError(Object error) {
    if (error is PlatformException) {
      if (error.code == 'google_sign_in' ||
          (error.message?.contains('GIDClientID') ?? false) ||
          (error.message?.contains('No active configuration') ?? false)) {
        return 'Google Sign-In is only available on Web or with registered iOS OAuth credentials. Please sign in with Email & Password.';
      }
      return error.message ?? 'Authentication error occurred.';
    }
    // Firebase error codes are technical, so translate common ones for users.
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'The email or password is incorrect.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'weak-password':
          return 'Use a stronger password with at least 6 characters.';
        case 'invalid-email':
          return 'Enter a valid email address.';
        case 'network-request-failed':
          return 'Could not connect. Check your internet connection.';
        case 'popup-closed-by-user':
        case 'canceled':
          return 'Google sign-in was cancelled.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    return error.toString().replaceFirst('Bad state: ', '');
  }
}
