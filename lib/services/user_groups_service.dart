import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/models/models.dart';

class UserGroupsService {
  CollectionReference userGroups =
      FirebaseFirestore.instance.collection('userGroups');

  UserGroupsController userGroupsController = Get.find();

  Future<List<UserGroups>> getUserGroups(String userId) async {
    userGroupsController.loading.value = true;

    try {
      if (userGroupsController.userGroupsList.isNotEmpty) {
        userGroupsController.userGroupsList.value = [];
      }

      final querySnapshot =
          await userGroups.where('userId', isEqualTo: userId).get();

      for (var doc in querySnapshot.docs) {
        userGroupsController.userGroupsList
            .add(UserGroups.fromMap(doc.data() as Map));
      }

      userGroupsController.loading.value = false;
      return userGroupsController.userGroupsList;
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error retrieving your groups');
      userGroupsController.loading.value = false;
      return [];
    }
  }

  Future addGroup(UserGroups userGroupsAdd) async {
    try {
      UsersController usersController = Get.find();
      await userGroups.add(userGroupsAdd.toMap());
      usersController.student.value = null;
      userGroupsController.userGroupsList.add(userGroupsAdd);
    } catch (e) {
      Snackbar.error('Unknown error',
          'There was an error attaching the group to the user');
    }
  }

  Future<int?> removeGroup(String groupId, String userId) async {
    try {
      final querySnapshot = await userGroups
          .where('userId', isEqualTo: userId)
          .where('groupId', isEqualTo: groupId)
          .get();

      final docRef = querySnapshot.docs[0].reference;

      await docRef.delete();

      final index = userGroupsController.userGroupsList
          .indexWhere((userGroups) => userGroups.groupId == groupId);
      userGroupsController.userGroupsList.value = userGroupsController
          .userGroupsList
          .where((userGroups) => userGroups.groupId == groupId)
          .toList();

      return index;
    } catch (e) {
      Snackbar.error('Unknown error',
          'There was an error removing the user from the group');
    }
  }

  Future updateStudentNumber(Group group) async {
    try {
      final _groups =
          await userGroups.where('groupId', isEqualTo: group.id).get();

      if (_groups.docs.isNotEmpty) {
        for (var _group in _groups.docs) {
          await _group.reference.set(
              {'groupStudentsNumber': group.members}, SetOptions(merge: true));
        }
      }
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error updating the number of users');
    }
  }
}
