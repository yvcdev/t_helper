import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:t_helper/models/user.dart';

class FBUserService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User? _user;
  String? error;

  User get user {
    return _user!;
  }

  set user(User user) {
    _user = user;
  }

  Future<User> getUser(User user) async {
    final documentSnapshot = await users.doc(user.uid).get();

    User partialUser = User(email: user.email, uid: user.uid);

    if (!documentSnapshot.exists) {
      return partialUser;
    }

    dynamic userData = documentSnapshot.data() as Map<String, dynamic>;

    userData = Map<String, dynamic>.from({
      'uid': partialUser.uid,
      'email': partialUser.email,
      ...userData,
    });

    User completeUser = User.fromMap(userData);

    return completeUser;
  }

  Future createUpdateUserInfo(User user) async {
    users.doc(user.uid).set(user.detailsToMap()).catchError((error) {
      error = 'An error occurred, please try again later';
    });
  }
}
