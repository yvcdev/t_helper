import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:t_helper/models/models.dart';

class FBUsersService extends ChangeNotifier {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User? student;
  String? error;
  String? message;
  bool loading = true;

  Future<User?> findUsersByEmail(String query) async {
    try {
      final querySnapshot = await users
          .where('email', isEqualTo: query)
          .where('role', isEqualTo: 'student')
          .get();

      if (querySnapshot.docs.isEmpty) {
        message = 'Student not found';
        error = null;
        notifyListeners();
        return null;
      }

      final userMap = querySnapshot.docs[0].data() as Map;

      final user = User.fromMap(userMap, querySnapshot.docs[0].id);

      student = user;
      error = null;
      message = null;
      notifyListeners();
      return user;
    } catch (e) {
      error = "There was an error finding the student";
      message = null;
      notifyListeners();
    }
  }

  //Future<List<User?>>
  getUsersInGroup(String groupId) async {
    try {
      loading = true;
      notifyListeners();

      //await users.where();

      loading = false;
      notifyListeners();
    } catch (e) {}
  }

  reset() {
    student = null;
    error = null;
    message = null;
    notifyListeners();
  }
}
