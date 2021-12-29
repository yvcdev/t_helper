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

  Future<bool> checkUserInGroup(String groupId, String userEmail) async {
    final _userInGroup = await groupUsers
        .where('groupId', isEqualTo: groupId)
        .where('userEmail', isEqualTo: userEmail)
        .get();

    if (_userInGroup.docs.isNotEmpty) {
      userInGroup = true;
      notifyListeners();
      print('Info checked true');
      return true;
    }

    userInGroup = false;
    notifyListeners();
    print('Info checked true');
    return false;
  }
}
