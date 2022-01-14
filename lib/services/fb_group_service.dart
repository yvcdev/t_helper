import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:t_helper/models/models.dart';

class FBGroupService extends ChangeNotifier {
  CollectionReference groupsReference =
      FirebaseFirestore.instance.collection('groups');
  CollectionReference groupUsersReference =
      FirebaseFirestore.instance.collection('groupUsers');

  List<Group>? groups;
  String? error;

  Future<List<Group>?> getGroups(User user) async {
    try {
      final querySnapshot =
          await groupsReference.where('owner', isEqualTo: user.uid).get();

      groups = [];

      for (var doc in querySnapshot.docs) {
        groups!.add(Group.fromMap(doc.data() as Map, doc.id));
      }

      error = null;
      return groups;
    } catch (e) {
      error = 'There was an error retrieving the groups';
    }
  }

  Future<String?> createGroup(Group group) async {
    try {
      final existingGroupQuery = await groupsReference
          .where('namedId', isEqualTo: group.namedId)
          .get();

      if (existingGroupQuery.docs.isNotEmpty) {
        error = 'A group with this ID already exists';
        return null;
      }

      final documentReference = await groupsReference.add(group.toMap());

      error = null;

      notifyListeners();
      return documentReference.id;
    } catch (e) {
      error = 'There was an error creating the group';
    }
  }

  Future<String?> updateGroup(String id, String field, dynamic value) async {
    try {
      await groupsReference.doc(id).set(
        {field: value},
        SetOptions(merge: true),
      );

      notifyListeners();
      error = null;
    } catch (e) {
      error = 'There was an error updating the group';
    }
  }

  Future deleteGroup(String groupId) async {
    try {
      final groupUsers =
          await groupUsersReference.where('groupId', isEqualTo: groupId).get();

      for (var groupUser in groupUsers.docs) {
        await groupUsersReference.doc(groupUser.id).delete();
      }

      await groupsReference.doc(groupId).delete();

      groups = groups!.where((group) => group.id != groupId).toList();

      notifyListeners();
    } catch (e) {
      error = 'There was an error deleting the group';
    }
  }
}
