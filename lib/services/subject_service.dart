import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/subject_controller.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/models/models.dart';

class SubjectService {
  CollectionReference subjectsReference =
      FirebaseFirestore.instance.collection('subjects');
  SubjectController subjectController = Get.find();

  Future<List<Subject>> getSubjects(String userId,
      {bool onlyActive = false}) async {
    subjectController.loading.value = true;

    try {
      if (subjectController.subjectList.isNotEmpty) {
        subjectController.subjectList.value = [];
      }

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
        subjectController.subjectList.add(_subject);
      }

      subjectController.subjectNumber.value =
          subjectController.subjectList.length;
      subjectController.loading.value = false;
      return subjectController.subjectList;
    } catch (e) {
      subjectController.loading.value = false;
      return [];
    }
  }

  Future<String?> addSubject(Subject subjectAdd) async {
    try {
      if (await checkSubjectExists(subjectAdd.namedId)) {
        Snackbar.error('Naming error', 'Subject already exists');
        return null;
      }

      final subject = await subjectsReference.add(subjectAdd.toMap());
      //TODO: add the subject to the group info - do it in functions file

      subjectController.subjectNumber.value =
          subjectController.subjectNumber.value + 1;

      subjectAdd.id = subject.id;

      subjectController.subjectList.insert(0, subjectAdd);

      return subject.id;
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error adding the user to the group');
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

      final index = subjectController.subjectList
          .indexWhere((subject) => subject.owner == userId);
      subjectController.subjectList.value = subjectController.subjectList
          .where((subject) => subject.owner != userId)
          .toList();

      return index;
    } catch (e) {
      Snackbar.error('Unknown error', 'There was an error deleting the group');
    }
  }

  Future<bool> updateSubject(
      String subjectId, String field, dynamic value) async {
    try {
      await subjectsReference.doc(subjectId).update({field: value});
      int subjectIndex = subjectController.subjectList
          .indexWhere((subject) => subject.id == subjectId);

      subjectController.subjectList[subjectIndex].active = value;
      return true;
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error updating the subject');
      return false;
    }
  }

  Future<bool> checkSubjectExists(String namedId) async {
    final _existingSubjects =
        await subjectsReference.where('namedId', isEqualTo: namedId).get();

    if (_existingSubjects.docs.isNotEmpty) {
      subjectController.subjectExists.value = true;
      return true;
    }

    subjectController.subjectExists.value = false;
    return false;
  }
}
