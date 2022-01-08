import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_helper/models/models.dart';

class FBGroupService {
  CollectionReference groupsReference =
      FirebaseFirestore.instance.collection('groups');

  List<Group>? groups;
  String? error;

  Future<List<Group>?> getGroups(User user) async {
    try {
      final querySnapshot =
          await groupsReference.where('owner', isEqualTo: user.uid).get();

      groups = [];

      for (var doc in querySnapshot.docs) {
        doc.data();
        final group = Group.fromSnapshot(doc, doc.id);
        print(group);
        groups!.add(group);
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
        //TODO: VERIFY IT CAN BE CREATED
        error = 'A group with this ID already exists';
        return null;
      }

      final documentReference = await groupsReference.add(group.toMap());

      error = null;

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

      error = null;
    } catch (e) {
      error = 'There was an error creating the group';
    }
  }
}
