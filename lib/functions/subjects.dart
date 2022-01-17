import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

Future subjectsOnSwitchChanged(
    BuildContext context, String subjectId, bool activate) async {
  final subjectService = Provider.of<FBSubjectService>(context, listen: false);

  await subjectService.updateSubject(subjectId, 'active', activate);

  //TODO: Show error message
}

Future subjectsOnAddPressed(
    BuildContext context,
    GlobalKey<FormState> formKey,
    GlobalKey<AnimatedListState> globalKey,
    TextEditingController formController) async {
  final addSubjectForm =
      Provider.of<AddSubjectFormProvider>(context, listen: false);
  final subjectService = Provider.of<FBSubjectService>(context, listen: false);
  final userService = Provider.of<FBUserService>(context, listen: false);

  if (!addSubjectForm.isValidForm(formKey)) return;

  final newSubject = Subject(
      name: addSubjectForm.subject.trim().toTitleCase(),
      namedId: addSubjectForm.subject.trim().toLowerCase(),
      owner: userService.user.uid,
      active: true);

  final subjectId = await subjectService.addSubject(newSubject);

  if (subjectService.error != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(message: subjectService.error!, success: false));
    addSubjectForm.isLoading = false;
  } else {
    newSubject.id = subjectId;
    subjectService.subjectList.insert(0, newSubject);

    globalKey.currentState!.insertItem(0);
    addSubjectForm.reset();
    formController.text = '';
    FocusScope.of(context).unfocus();
  }
}
