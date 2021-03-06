import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/group_controller.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/models/models.dart';

class GroupService {
  CollectionReference groupsReference =
      FirebaseFirestore.instance.collection('groups');
  CollectionReference groupUsersReference =
      FirebaseFirestore.instance.collection('groupUsers');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  GroupController groupController = Get.find();

  Stream<List<Group>> getGroups(User user) {
    return groupsReference
        .where('owner', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Group.fromMap(doc.data() as Map, doc.id);
      }).toList();
    });
  }

  Future<List<String>> getStudentGroupsIds(User student) async {
    final result =
        await groupUsersReference.where('userId', isEqualTo: student.uid).get();

    final groupsList = result.docs
        .map((groupUsers) =>
            GroupUsers.fromMap(groupUsers.data() as Map).groupId)
        .toList();

    return groupsList;
  }

  Future<List<Group>> getStudentGroups(List<String> groupIds) async {
    final result =
        await groupsReference.where('id', arrayContains: groupIds).get();

    final _groups = result.docs
        .map((group) => Group.fromMap(group as Map, group.id))
        .toList();

    return _groups;
  }

  Future<String?> createGroup(Group group) async {
    try {
      final existingGroupQuery = await groupsReference
          .where('namedId', isEqualTo: group.namedId)
          .get();

      if (existingGroupQuery.docs.isNotEmpty) {
        Snackbar.error('ID Error', 'A group with this ID already exists');
        return null;
      }

      final documentReference = await groupsReference.add(group.toMap());

      return documentReference.id;
    } catch (e) {
      Snackbar.error('Unknown error', 'There was an error creating the group');
      return null;
    }
  }

  Future<String?> updateGroup(String id, String field, dynamic value) async {
    try {
      await groupsReference.doc(id).set(
        {field: value},
        SetOptions(merge: true),
      );
      return id;
    } catch (e) {
      Snackbar.error('Unknown error', 'There was an error updating the group');
      return null;
    }
  }

  Future<String?> updateGroupNoImage(Group group) async {
    try {
      await groupsReference.doc(group.id).set(
        {'name': group.name, 'subject': group.subject, 'level': group.level},
        SetOptions(merge: true),
      );
      return group.id;
    } catch (e) {
      Snackbar.error('Unknown error', 'There was an error updating the group');
      return null;
    }
  }

  Future<String?> updateGroupWithImage(Group group) async {
    try {
      await groupsReference.doc(group.id).set(
        {
          'name': group.name,
          'subject': group.subject,
          'level': group.level,
          'image': group.image
        },
        SetOptions(merge: true),
      );
      return group.id;
    } catch (e) {
      Snackbar.error('Unknown error', 'There was an error updating the group');
      return null;
    }
  }

  Future deleteGroup(String groupId, String imageUrl) async {
    try {
      groupController.isLoading.value = true;
      final groupUsers =
          await groupUsersReference.where('groupId', isEqualTo: groupId).get();

      for (var groupUsers in groupUsers.docs) {
        await groupUsersReference.doc(groupUsers.id).delete();
      }

      await groupsReference.doc(groupId).delete();

      if (imageUrl != '') {
        await storage.refFromURL(imageUrl).delete();
      }

      groupController.groups.value =
          groupController.groups.where((group) => group.id != groupId).toList();

      groupController.isLoading.value = false;
    } catch (e) {
      groupController.isLoading.value = false;
      Snackbar.error('Unknown error', 'There was an error deleting the group');
    }
  }

  Future<bool> deletePicture(String imageUrl) async {
    try {
      groupController.isLoading.value = true;
      await storage.refFromURL(imageUrl).delete();
      groupController.isLoading.value = false;
      return true;
    } catch (e) {
      groupController.isLoading.value = false;
      Snackbar.error(
          'Unknown error', 'There was an error removing the picture');
      return false;
    }
  }

  Future<Group?> getGroup(String groupId) async {
    try {
      groupController.isLoading.value = true;
      final _group = await groupsReference.doc(groupId).get();

      if (_group.exists) {
        groupController.isLoading.value = false;
        return Group.fromMap(_group.data() as Map, _group.id);
      }
      groupController.isLoading.value = false;
      return null;
    } catch (e) {
      groupController.isLoading.value = false;
      Snackbar.error(
          'Unknown error', 'There was an error retrieving the group');
      return null;
    }
  }
}
