import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/controllers.dart';

import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/utils/generate_unique_id.dart';

Future subjectsOnSwitchChanged(
    BuildContext context, String subjectId, bool activate, int index) async {
  SubjectController subjectController = Get.find();

  await subjectController.updateSubject(subjectId, 'active', activate, index);
}

Future subjectsOnSendNewNamePressed(
    BuildContext context,
    String subjectId,
    String newName,
    int index,
    GlobalKey<FormState> formKey,
    TextEditingController formController) async {
  SubjectController subjectController = Get.find();
  AddSubjectFormController addSubjectForm = Get.find();

  if (newName == subjectController.subjectList[index].name) {
    Snackbar.error('Subject name', 'Please write a new name');
    return;
  }

  if (!addSubjectForm.isValidForm(formKey) || addSubjectForm.subject.isEmpty) {
    Snackbar.error('Subject name', 'Please write a valid name');
    return;
  }

  bool wasUpdated = await subjectController.updateSubject(
      subjectId, 'name', newName.trim().toTitleCase(), index);

  if (wasUpdated) {
    addSubjectForm.reset();
    subjectController.editionMode.value = false;
    formController.text = '';
    formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
  }
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

  if (!addSubjectForm.isValidForm(formKey) || addSubjectForm.subject.isEmpty) {
    Snackbar.error('Subject name', 'Please write a valid name');
    return;
  }

  String subject = addSubjectForm.subject.trim();

  final newSubject = Subject(
      name: addSubjectForm.subject.trim().toTitleCase(),
      namedId: generateUniqueId(subject, 1, 's'),
      owner: user.value!.uid,
      active: true);

  if (newSubject.name == 'Create Subject') {
    Snackbar.error(
        'Subject name', 'A subject with this name cannot be created');
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

Future subjectOnEditPress(BuildContext context, String subjectId, String name,
    int index, TextEditingController textController) async {
  SubjectController subjectController = Get.find();

  textController.text = name;
  subjectController.editionMode.value = true;
  subjectController.subjectToDelete.value = subjectId;
}

Future subjectOnDeleteSubjectPressed(
    BuildContext context,
    String subjectId,
    TextEditingController textController,
    GlobalKey<AnimatedListState> globalKey,
    Tween<Offset> offset) async {
  SubjectController subjectController = Get.find();

  int? index = await subjectController.deleteSubject(subjectId);

  if (index != null) {
    globalKey.currentState!.removeItem(
        index,
        (_, animation) => SlideTransition(
              position: animation.drive(offset),
            ));
    subjectController.editionMode.value = false;
    textController.text = '';
    FocusScope.of(context).unfocus();
  }
}
