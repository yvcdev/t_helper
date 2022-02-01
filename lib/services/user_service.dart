import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_helper/controllers/user_controller.dart';

import 'package:t_helper/models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User> getUser(String uid) {
    print('get user called with uid: $uid');
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return User(email: '', uid: '');
      } else {
        return User.fromSnapshot(snapshot, uid);
      }
    });
  }
}
