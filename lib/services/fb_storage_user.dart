import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import 'package:t_helper/models/user.dart';

class FBStorageUser {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String? error;

  Future<String?> uploadProfilePicture(String path, String uid) async {
    File file = File(path);
    String extension = path.split(".").last;

    try {
      await storage
          .ref('users/$uid/profilePicture/profile-picture.$extension')
          .putFile(file);

      String downloadUrl = await storage
          .ref('users/$uid/profilePicture/profile-picture.$extension')
          .getDownloadURL();

      return downloadUrl;
    } on firebase_core.FirebaseException catch (e) {
      if (e.code == 'canceled') {
        error = 'The upload was canceled';
      } else {
        error = 'Please try again later';
      }
    } catch (e) {
      error = 'Please try again later';
    }
  }
}
