import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/models/models.dart';

class GroupUsersService {
  CollectionReference groupUsers =
      FirebaseFirestore.instance.collection('groupUsers');

  GroupUsersController groupUsersController = Get.find();

  Future<List<GroupUsers>> getGroupUsers(String groupId) async {
    groupUsersController.loading.value = true;

    try {
      if (groupUsersController.groupUsersList.isNotEmpty) {
        groupUsersController.groupUsersList.value = [];
      }

      final querySnapshot =
          await groupUsers.where('groupId', isEqualTo: groupId).get();

      for (var doc in querySnapshot.docs) {
        groupUsersController.groupUsersList
            .add(GroupUsers.fromMap(doc.data() as Map));
      }

      groupUsersController.loading.value = false;
      return groupUsersController.groupUsersList;
    } catch (e) {
      Snackbar.error('Unknown error',
          'There was an error getting the users in this group');
      groupUsersController.loading.value = false;
      return [];
    }
  }

  Future addUserToGroup(GroupUsers groupUserAdd) async {
    try {
      UsersController usersController = Get.find();
      await groupUsers.add(groupUserAdd.toMap());
      usersController.student.value = null;
      groupUsersController.groupUsersList.add(groupUserAdd);
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error adding the user to the group');
    }
  }

  Future<int?> removeUserFromGroup(String groupId, String userId) async {
    try {
      final querySnapshot = await groupUsers
          .where('userId', isEqualTo: userId)
          .where('groupId', isEqualTo: groupId)
          .get();

      final docRef = querySnapshot.docs[0].reference;

      await docRef.delete();

      final index = groupUsersController.groupUsersList
          .indexWhere((groupUsers) => groupUsers.userId == userId);
      groupUsersController.groupUsersList.value = groupUsersController
          .groupUsersList
          .where((groupUser) => groupUser.userId != userId)
          .toList();

      UsersController usersController = Get.find();
      usersController.student.value = null;

      return index;
    } catch (e) {
      Snackbar.error('Unknown error',
          'There was an error removing the user from the group');
      return null;
    }
  }

  Future<bool> checkUserInGroup(String groupId, String userEmail) async {
    try {
      final _userInGroup = await groupUsers
          .where('groupId', isEqualTo: groupId)
          .where('userEmail', isEqualTo: userEmail)
          .get();

      if (_userInGroup.docs.isNotEmpty) {
        groupUsersController.userInGroup.value = true;
        return true;
      }

      groupUsersController.userInGroup.value = false;
      return false;
    } catch (e) {
      Snackbar.error('Unknown error', 'Please check the user again');
      return false;
    }
  }

  Future<bool> updateUserInfo(User user) async {
    try {
      final _result =
          await groupUsers.where('userId', isEqualTo: user.uid).get();

      if (_result.docs.isNotEmpty) {
        for (var groupUser in _result.docs) {
          await groupUser.reference.set({
            'userEmail': user.email,
            'userFirstName': user.firstName,
            'userMiddleName': user.middleName,
            'userLastName': user.lastName,
            'userProfilePic': user.profilePic
          }, SetOptions(merge: true));
        }
      }
      return true;
    } catch (e) {
      Snackbar.error('Unknown error',
          'There was an error updating the information in the groups');
      return false;
    }
  }
}
