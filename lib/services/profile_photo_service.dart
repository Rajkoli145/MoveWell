import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_service.dart';

class ProfilePhotoService {
  // Shared picker service for the profile editor.
  ProfilePhotoService._();

  static final instance = ProfilePhotoService._();
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndUpload({
    ImageSource source = ImageSource.gallery,
  }) async {
    // The picker can be cancelled, which is not an error.
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );
    if (image == null) {
      return null;
    }

    // Check the byte size before uploading to respect Storage limits.
    final bytes = await image.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw StateError('Choose an image smaller than 5 MB.');
    }

    final extension = image.name.contains('.')
        ? image.name.split('.').last.toLowerCase()
        : 'jpg';
    final contentType = extension == 'png' ? 'image/png' : 'image/jpeg';

    // 1. Attempt uploading to Firebase Storage if signed in
    final User? user = AuthService.instance.currentUser;
    if (user != null) {
      try {
        final reference = FirebaseStorage.instance.ref(
          'users/${user.uid}/avatar/profile.$extension',
        );
        await reference.putData(
          bytes,
          SettableMetadata(contentType: contentType),
        );
        return await reference.getDownloadURL();
      } catch (_) {
        // Storage unreachable or restricted: proceed to local base64 fallback
      }
    }

    // 2. Offline / local fallback: persistent data URI
    final base64String = base64Encode(bytes);
    return 'data:$contentType;base64,$base64String';
  }
}
