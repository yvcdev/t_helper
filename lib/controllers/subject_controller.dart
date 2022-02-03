import 'package:get/get.dart';
import 'package:t_helper/models/subject.dart';
import 'package:t_helper/services/subject_service.dart';

class SubjectController extends GetxController {
  Rx<List<Subject>> subjectList = Rx([]);
  var subjectNumber = 0.obs;
  var loading = true.obs;
  var subjectExists = false.obs;

  Future<List<Subject>> getSubjects(String userId,
      {bool onlyActive = false}) async {
    final response = await SubjectService().getSubjects(userId);
    return response;
  }

  Future<String?> addSubject(Subject subjectAdd) async {
    final response = await SubjectService().addSubject(subjectAdd);
    return response;
  }

  Future<int?> removeSubjectFromGroup(String userId) async {
    final response = await SubjectService().removeSubjectFromGroup(userId);
    return response;
  }

  Future updateSubject(
      String subjectId, String field, dynamic value, int index) async {
    final response =
        await SubjectService().updateSubject(subjectId, field, value);

    if (response != null && field == 'active') {
      subjectList.value[index].active = value;
    }

    return response;
  }

  Future<bool> checkSubjectExists(String namedId) async {
    final response = await SubjectService().checkSubjectExists(namedId);
    return response;
  }
}
