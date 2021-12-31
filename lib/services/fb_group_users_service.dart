import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:t_helper/models/models.dart';

class FBGroupUsersService extends ChangeNotifier {
  CollectionReference groupUsers =
      FirebaseFirestore.instance.collection('groupUsers');
  List<GroupUsers> groupUsersList = [];
  String? error;
  bool loading = true;
  bool userInGroup = false;

  Future<List<GroupUsers>> getGroupUsers(String groupId) async {
    loading = true;
    notifyListeners();

    try {
      if (groupUsersList.isNotEmpty) groupUsersList = [];

      final querySnapshot =
          await groupUsers.where('groupId', isEqualTo: groupId).get();

      for (var doc in querySnapshot.docs) {
        groupUsersList.add(GroupUsers.fromMap(doc.data() as Map));
      }

      loading = false;
      notifyListeners();
      error = null;
      return groupUsersList;
    } catch (e) {
      error = 'There was an error getting the users in this group';
      loading = false;
      notifyListeners();
      return [];
    }
  }

  Future addUserToGroup(GroupUsers groupUserAdd) async {
    try {
      await groupUsers.add(groupUserAdd.toMap());

      notifyListeners();
    } catch (e) {
      error = 'There was an error adding the user to the group';
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

      final index = groupUsersList
          .indexWhere((groupUsers) => groupUsers.userId == userId);
      groupUsersList = groupUsersList
          .where((groupUsers) => groupUsers.userId != userId)
          .toList();

      notifyListeners();
      print('User deleted');

      return index;
    } catch (e) {
      print('User not deleted');
      error = 'There was an error removing the user to the group';
      notifyListeners();
    }
  }

  Future<bool> checkUserInGroup(String groupId, String userEmail) async {
    final _userInGroup = await groupUsers
        .where('groupId', isEqualTo: groupId)
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (_userInGroup.docs.isNotEmpty) {
      userInGroup = true;
      notifyListeners();
      return true;
    }

    userInGroup = false;
    notifyListeners();
    return false;
  }
}
