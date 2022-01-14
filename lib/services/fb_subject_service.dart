import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:t_helper/models/models.dart';

class FBSubjectService extends ChangeNotifier {
  CollectionReference subjectsReference =
      FirebaseFirestore.instance.collection('subjects');
  List<Subject> subjectList = [];
  String? error;
  int subjectNumber = 0;
  bool loading = true;
  bool subjectExists = false;

  Future<List<Subject>> getSubjects(String userId) async {
    loading = true;
    notifyListeners();

    try {
      if (subjectList.isNotEmpty) subjectList = [];

      final querySnapshot =
          await subjectsReference.where('owner', isEqualTo: userId).get();

      for (var doc in querySnapshot.docs) {
        subjectList.add(Subject.fromMap(doc.data() as Map));
      }

      subjectNumber = subjectList.length;
      loading = false;
      notifyListeners();
      error = null;
      return subjectList;
    } catch (e) {
      error = 'There was an error getting your subjects';
      loading = false;
      notifyListeners();
      return [];
    }
  }

  Future addSubject(Subject subjectAdd) async {
    try {
      await subjectsReference.add(subjectAdd.toMap());
      //TODO: add the subject to the group info - do it in functions file

      notifyListeners();
    } catch (e) {
      error = 'There was an error adding the user to the group';
    }
  }

  Future<int?> removeSubjectFromGroup(String userId) async {
    try {
      final subjects =
          await subjectsReference.where('owner', isEqualTo: userId).get();

      for (var subject in subjects.docs) {
        await subjectsReference.doc(subject.id).delete();
      }

      await subjectsReference.doc(userId).delete();

      final index =
          subjectList.indexWhere((subject) => subject.owner == userId);
      subjectList =
          subjectList.where((subject) => subject.owner != userId).toList();

      notifyListeners();
      return index;
    } catch (e) {
      error = 'There was an error deleting the group';
      notifyListeners();
    }
  }

  Future updateSubject(String subjectId, String field, dynamic value) async {
    try {
      await subjectsReference.doc(subjectId).update({field: value});
    } catch (e) {
      error = "There was an error updating the subject";
    }
  }

  Future<bool> checkUserInGroup(String userId) async {
    final _existingSubjects =
        await subjectsReference.where('groupId', isEqualTo: userId).get();

    if (_existingSubjects.docs.isNotEmpty) {
      subjectExists = true;
      notifyListeners();
      return true;
    }

    subjectExists = false;
    notifyListeners();
    return false;
  }
}
