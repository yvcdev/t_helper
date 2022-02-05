import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';

createGroupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  CreateGroupFormController createGroupForm = Get.find();
  GroupController groupController = Get.find();
  UserController userController = Get.find();
  final user = userController.user;
  final now = DateTime.now();
  String? downloadUrl;

  if (createGroupForm.subject['name'] == '') {
    Snackbar.error('Subject selection', 'A subject needs to be selected');
    return;
  }

  if (!createGroupForm.isValidForm(formKey)) return;

  createGroupForm.isLoading.value = true;
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
      level: createGroupForm.level.value,
      members: 0,
      activities: []);

  final groupId = await groupController.createGroup(group);

  if (groupId != null) {
    group.id = groupId;
    if (createGroupForm.selectedImage.value != null) {
      final storageGroupService = Get.put(StorageGroupService());

      downloadUrl = await storageGroupService.uploadGroupPicture(
          createGroupForm.selectedImage.value!, groupId);

      if (downloadUrl != null) {
        await groupController.updateGroup(groupId, 'image', downloadUrl);

        group.image = downloadUrl;

        createGroupForm.isLoading.value = false;
      } else {
        return;
      }
    }
  }

  CurrentGroupController currentGroupController = Get.find();

  currentGroupController.currentGroup.value = group;

  Get.off(() => const GroupInfoScreen());
  createGroupForm.reset();
}

createGroupOnSubjectTextTap(BuildContext context) async {
  SubjectController subjectController = Get.find();
  UserController userController = Get.find();
  CreateGroupFormController createGroupForm = Get.find();

  final user = userController.user;
  final userId = user.value.uid;

  createGroupForm.subject.value = {'name': '', 'id': ''};

  Get.to(() => SubjectsScreen());

  await subjectController.getSubjects(userId);
}
