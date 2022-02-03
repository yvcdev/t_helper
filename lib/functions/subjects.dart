import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/controllers/subject_controller.dart';

import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/utils/utils.dart';

Future subjectsOnSwitchChanged(
    BuildContext context, String subjectId, bool activate, int index) async {
  SubjectController subjectController = Get.find();

  await subjectController.updateSubject(subjectId, 'active', activate, index);
}

Future subjectsOnAddPressed(
    BuildContext context,
    GlobalKey<FormState> formKey,
    GlobalKey<AnimatedListState> globalKey,
    TextEditingController formController) async {
  AddSubjectFormController addSubjectForm = Get.find();
  SubjectController subjectController = Get.find();

  UserController userController = Get.find();
  final user = userController.user;

  if (!addSubjectForm.isValidForm(formKey)) return;

  final newSubject = Subject(
      name: addSubjectForm.subject.trim().toTitleCase(),
      namedId: addSubjectForm.subject.trim().toLowerCase(),
      owner: user.value.uid,
      active: true);

  if (newSubject.namedId == 'createSubject' ||
      newSubject.name == 'Create Subject') {
    ScaffoldMessenger.of(context).showSnackBar(snackbar(
        message: 'A subject with this name cannot be created', success: false));
    addSubjectForm.isLoading.value = false;
    return;
  }

  final subjectId = await subjectController.addSubject(newSubject);

  if (subjectId != null) {
    globalKey.currentState!.insertItem(0);
    addSubjectForm.reset();
    formController.text = '';
    FocusScope.of(context).unfocus();
  }
}
