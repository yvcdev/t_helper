import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'package:t_helper/models/models.dart';

class FBAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  String? error;

  User? _userFromFirebase(auth.User? user) {
    if (user == null) return null;

    return User(user.email!, user.uid);
  }

  Stream<User?>? get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      error = null;
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user';
      }
    }
  }

  Future<User?> signup(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      error = null;
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
