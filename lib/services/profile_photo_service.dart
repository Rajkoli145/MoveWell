import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_service.dart';

class ProfilePhotoService {
  // Shared picker service for the profile editor.
  ProfilePhotoService._();

  static final instance = ProfilePhotoService._();
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndUpload() async {
    // The gallery can be cancelled, which is not an error.
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (image == null) {
      return null;
    }

    final User? user = AuthService.instance.currentUser;
    if (user == null) {
      throw StateError('Please sign in before changing your photo.');
    }
    // Check the byte size before uploading to respect Storage security limits.
    final bytes = await image.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      throw StateError('Choose an image smaller than 5 MB.');
    }

    final extension = image.name.contains('.')
        ? image.name.split('.').last.toLowerCase()
        : 'jpg';
    final contentType = extension == 'png' ? 'image/png' : 'image/jpeg';
    // A deterministic path replaces a user's older avatar rather than creating
    // an unbounded list of profile-photo files.
    final reference = FirebaseStorage.instance.ref(
      'users/${user.uid}/avatar/profile.$extension',
    );
    await reference.putData(bytes, SettableMetadata(contentType: contentType));
    return reference.getDownloadURL();
  }
}
