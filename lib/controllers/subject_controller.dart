import 'package:get/get.dart';
import 'package:t_helper/models/subject.dart';
import 'package:t_helper/services/subject_service.dart';

class SubjectController extends GetxController {
  var subjectList = RxList<Subject>([]);
  var editionMode = false.obs;
  var subjectToDelete = ''.obs;
  var subjectNumber = 0.obs;
  var loading = true.obs;
  var subjects = [
    {
      "name": '',
      "id": '',
    },
    {
      "name": 'Edit/Create',
      "id": 'createSubject',
    },
  ].obs;

  filterActiveSubjects() {
    subjects.value = [];
    for (var subject in subjectList) {
      if (subject.active) {
        subjects.add({"name": subject.name, "id": subject.id!});
        subjects.sort((a, b) => (a['name']!.compareTo(b['name']!)));
      }
    }

    subjects.insertAll(0, [
      {
        "name": '',
        "id": '',
      },
      {
        "name": 'Edit/Create',
        "id": 'createSubject',
      }
    ]);
  }

  Future<List<Subject>> getSubjects(String userId,
      {bool onlyActive = false}) async {
    final response = await SubjectService().getSubjects(userId);
    filterActiveSubjects();
    return response;
  }

  Future<String?> addSubject(Subject subjectAdd) async {
    final response = await SubjectService().addSubject(subjectAdd);
    filterActiveSubjects();
    return response;
  }

  Future<int?> removeSubjectFromGroup(String userId) async {
    final response = await SubjectService().removeSubjectFromGroup(userId);
    filterActiveSubjects();
    return response;
  }

  Future<bool> updateSubject(
      String subjectId, String field, dynamic value, int index) async {
    final wasUpdated =
        await SubjectService().updateSubject(subjectId, field, value);

    if (wasUpdated) {
      filterActiveSubjects();
      update();
    }

    return wasUpdated;
  }

  Future<int?> deleteSubject(String subjectId) async {
    final response = await SubjectService().deleteSubject(subjectId);
    filterActiveSubjects();
    return response;
  }
}
