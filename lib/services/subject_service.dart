import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/subject_controller.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/models/models.dart';
import 'package:t_helper/utils/generate_unique_id.dart';

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
      int sequence = 2;

      int index = checkSubjectNameExists(subjectAdd.name);
      if (index != -1) {
        return null;
      }

      await Future.doWhile(() async {
        bool _exists = await checkIdExists(subjectAdd.namedId);

        if (_exists) {
          String namedId = generateUniqueId(subjectAdd.name, sequence, 's');
          subjectAdd.namedId = namedId;
          sequence++;
        }

        return _exists;
      });
      var subject = await subjectsReference.add(subjectAdd.toMap());
      //TODO: add the subject to the group info - do it in functions file

      subjectAdd.id = subject.id;

      subjectController.subjectList.insert(0, subjectAdd);

      subjectController.subjectNumber.value =
          subjectController.subjectList.length;

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
      Snackbar.error(
          'Unknown error', 'There was an error deleting the subject');
    }
  }

  Future<bool> updateSubject(
      String subjectId, String field, dynamic value) async {
    try {
      await subjectsReference.doc(subjectId).update({field: value});
      int subjectIndex = subjectController.subjectList
          .indexWhere((subject) => subject.id == subjectId);

      if (field == 'active') {
        subjectController.subjectList[subjectIndex].active = value;
      } else {
        subjectController.subjectList[subjectIndex].name = value;
      }
      return true;
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error updating the subject');
      return false;
    }
  }

  Future<bool> checkIdExists(String namedId) async {
    final _existingSubjects =
        await subjectsReference.where('namedId', isEqualTo: namedId).get();

    if (_existingSubjects.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  int checkSubjectNameExists(String subjectName) {
    final index = subjectController.subjectList.indexWhere((subject) =>
        subjectName.trim().toLowerCase() == subject.name.trim().toLowerCase());

    if (index != -1) {
      Snackbar.error('Naming error', 'Subject already exists');
    }

    return index;
  }

  Future<int?> deleteSubject(String subjectId) async {
    try {
      subjectsReference.doc(subjectId).delete();

      final index = subjectController.subjectList
          .indexWhere((subject) => subject.id == subjectId);

      subjectController.subjectList.removeAt(index);

      subjectController.subjectNumber.value =
          subjectController.subjectList.length;

      return index;
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'There was an error deleting the subject');
    }
  }
}
