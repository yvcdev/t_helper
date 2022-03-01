import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';

import 'package:t_helper/controllers/users_controller.dart';
import 'package:t_helper/models/models.dart';

class UsersService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  UsersController usersController = Get.find();

  Future<User?> findUserByEmail(String query) async {
    try {
      final querySnapshot = await users
          .where('email', isEqualTo: query)
          .where('role', isEqualTo: 'student')
          .get();

      if (querySnapshot.docs.isEmpty) {
        usersController.message.value = 'Student not found';
        usersController.error.value = null;
        return null;
      }

      final userMap = querySnapshot.docs[0].data() as Map;

      final user = User.fromMap(userMap, querySnapshot.docs[0].id);

      usersController.error.value = null;
      usersController.message.value = null;
      return user;
    } catch (e) {
      usersController.error.value = "There was an error finding the student";
      usersController.message.value = null;
      return null;
    }
  }
}
