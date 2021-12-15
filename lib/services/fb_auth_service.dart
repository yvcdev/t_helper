import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FBAuthService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? error;

  final Map<String, dynamic> _user = {'email': '', 'uid': 0};
  Map<String, dynamic> get user => _user;

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      _user['email'] = userCredential.user!.email;
      _user['uid'] = userCredential.user!.uid;
      _user['token'] = userCredential.credential == null
          ? 0
          : userCredential.credential!.token;
      error = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user';
      }
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _user['email'] = userCredential.user!.email;
      _user['uid'] = userCredential.user!.uid;
      _user['token'] = userCredential.credential == null
          ? 0
          : userCredential.credential!.token;
      error = null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email';
      }
    } catch (e) {
      print(e);
    }
  }
}
