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
    }
  }

  Future deleteGroup(String groupId, String imageUrl) async {
    try {
      groupController.isLoading.value = true;
      final groupUsers =
          await groupUsersReference.where('groupId', isEqualTo: groupId).get();

      for (var groupUser in groupUsers.docs) {
        await groupUsersReference.doc(groupUser.id).delete();
      }

      await groupsReference.doc(groupId).delete();

      if (imageUrl != '') {
        await storage.refFromURL(imageUrl).delete();
      }

      groupController.groups.value =
          groupController.groups.where((group) => group.id != groupId).toList();
    } catch (e) {
      Snackbar.error('Unknown error', 'There was an error deleting the group');
    }
  }
}
