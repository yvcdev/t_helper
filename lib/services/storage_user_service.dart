import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:t_helper/helpers/helpers.dart';

class StorageUserService {
  static final _storage = firebase_storage.FirebaseStorage.instance;

  String? error;

  static Future<String?> uploadProfilePicture(String path, String uid) async {
    File file = File(path);
    String extension = path.split(".").last;

    try {
      await _storage
          .ref('users/$uid/profilePicture/profile-picture.$extension')
          .putFile(file);

      String downloadUrl = await _storage
          .ref('users/$uid/profilePicture/profile-picture.$extension')
          .getDownloadURL();

      return downloadUrl;
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'canceled') {
        Snackbar.error('Canceled', 'The upload was canceled');
      } else {
        Snackbar.error('Unknown Error', 'Please try again later');
      }
      return null;
    } catch (e) {
      Snackbar.error('Unknown Error', 'Please try again later');
      return null;
    }
  }

  static Future<bool> deleteProfilePicture(String imageUrl) async {
    try {
      await _storage.refFromURL(imageUrl).delete();
      return true;
    } catch (e) {
      Snackbar.error(
          'Image deletion', 'The profile picture could not be deleted');
      return false;
    }
  }
}
