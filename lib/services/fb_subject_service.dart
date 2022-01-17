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

  Future<List<Subject>> getSubjects(String userId,
      {bool onlyActive = false}) async {
    loading = true;
    notifyListeners();

    try {
      if (subjectList.isNotEmpty) subjectList = [];

      final querySnapshot = onlyActive
          ? await subjectsReference
              .where('owner', isEqualTo: userId)
              .where('active', isEqualTo: true)
              .orderBy('name', descending: false)
              .get()
          : await subjectsReference
              .where('owner', isEqualTo: userId)
              .orderBy('active', descending: true)
              .orderBy('name', descending: false)
              .get();

      for (var doc in querySnapshot.docs) {
        final _subject = Subject.fromMap(doc.data() as Map);
        _subject.id = doc.id;
        subjectList.add(_subject);
      }

      subjectNumber = subjectList.length;
      loading = false;
      notifyListeners();
      error = null;
      return subjectList;
    } catch (e) {
      error = 'There was an error getting your subjects';
      loading = false;
      print(e);
      notifyListeners();
      return [];
    }
  }

  Future<String?> addSubject(Subject subjectAdd) async {
    try {
      if (await checkSubjectExists(subjectAdd.namedId)) {
        error = "Subject already exists";
        return null;
      }

      final subject = await subjectsReference.add(subjectAdd.toMap());
      error = null;
      //TODO: add the subject to the group info - do it in functions file

      subjectNumber = subjectNumber + 1;
      notifyListeners();
      return subject.id;
    } catch (e) {
      error = 'There was an error adding the user to the group';
      notifyListeners();
      return null;
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

  Future<bool> checkSubjectExists(String namedId) async {
    final _existingSubjects =
        await subjectsReference.where('namedId', isEqualTo: namedId).get();

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
