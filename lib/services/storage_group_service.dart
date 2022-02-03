import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:t_helper/helpers/helpers.dart';

class StorageGroupService {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadGroupPicture(String path, String groupId) async {
    File file = File(path);
    String extension = path.split(".").last;

    try {
      await storage
          .ref('groups/$groupId/profilePicture/profile-picture.$extension')
          .putFile(file);

      String downloadUrl = await storage
          .ref('groups/$groupId/profilePicture/profile-picture.$extension')
          .getDownloadURL();

      return downloadUrl;
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'canceled') {
        Snackbar.error('Canceled', 'The upload was canceled');
      } else {
        Snackbar.error('Unknown error', 'Please try again later');
      }
    } catch (e) {
      Snackbar.error('Unknown error', 'Please try again later');
    }
  }
}
