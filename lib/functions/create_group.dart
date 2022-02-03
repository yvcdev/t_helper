import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

createGroupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  final createGroupForm =
      Provider.of<CreateGroupFormProvider>(context, listen: false);
  final groupService = Provider.of<FBGroupService>(context, listen: false);
  UserController userController = Get.find();
  final user = userController.user;
  final now = DateTime.now();
  String? downloadUrl;

  if (createGroupForm.subject['name'] == '') {
    ScaffoldMessenger.of(context).showSnackBar(
        snackbar(message: 'A subject needs to be selected', success: false));
    return;
  }

  if (!createGroupForm.isValidForm(formKey)) return;

  createGroupForm.isLoading = true;
  createGroupForm.getGroupId();

  final group = Group(
      id: '',
      name: createGroupForm.name.trim(),
      namedId: createGroupForm.groupId! +
          '${now.year}' +
          '${now.month}' +
          '${now.day}' +
          '${now.hour}',
      owner: user.value.uid,
      subject: {
        'name': createGroupForm.subject['name']!,
        'id': createGroupForm.subject['id']!
      },
      level: createGroupForm.level,
      members: 0,
      activities: []);

  final groupId = await groupService.createGroup(group);

  if (groupService.error != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(message: groupService.error!, success: false));
    createGroupForm.isLoading = false;
  } else {
    group.id = groupId!;
    if (createGroupForm.selectedImage != null) {
      final groupStorageService =
          Provider.of<FBStorageGroup>(context, listen: false);

      downloadUrl = await groupStorageService.uploadGroupPicture(
          createGroupForm.selectedImage!, groupId);

      if (downloadUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            snackbar(message: groupStorageService.error!, success: false));
        return;
      } else {
        await groupService.updateGroup(groupId, 'image', downloadUrl);
        group.image = downloadUrl;

        if (groupService.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
              snackbar(message: groupService.error!, success: false));
          createGroupForm.isLoading = false;
        }
      }
    }

    CurrentGroupController currentGroupController = Get.find();

    currentGroupController.currentGroup.value = group;

    Get.off(() => const GroupInfoScreen());
    createGroupForm.reset();
  }
}

createGroupOnSubjectTextTap(BuildContext context) async {
  final subjectService = Provider.of<FBSubjectService>(context, listen: false);
  UserController userController = Get.find();
  final user = userController.user;
  final createGroupForm =
      Provider.of<CreateGroupFormProvider>(context, listen: false);

  final userId = user.value.uid;

  createGroupForm.subject = {'name': '', 'id': ''};

  Get.to(() => const SubjectsScreen());

  await subjectService.getSubjects(userId);
}
