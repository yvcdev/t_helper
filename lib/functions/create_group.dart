import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

createGroupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  CreateGroupFormController createGroupForm = Get.find();
  GroupController groupController = Get.find();
  UserController userController = Get.find();
  final user = userController.user;
  String? downloadUrl;

  if (createGroupForm.subject['name'] == '') {
    Snackbar.error('Subject selection', 'A subject needs to be selected');
    return;
  }

  if (!createGroupForm.isValidForm(formKey)) return;

  createGroupForm.isLoading.value = true;

  final group = Group(
      id: '',
      name: createGroupForm.name.trim().toTitleCase(),
      namedId: generateUniqueId(createGroupForm.name.value, 1, 'g'),
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

  Get.to(() => const SubjectsScreen(),
      arguments: {'showNotificationIcon': false});

  await subjectController.getSubjects(userId);
}

editGroupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  CreateGroupFormController createGroupForm = Get.find();
  GroupController groupController = Get.find();
  CurrentGroupController currentGroupController = Get.find();
  final currentGroup = currentGroupController.currentGroup.value;
  String? downloadUrl;

  if (currentGroup!.image == createGroupForm.selectedImage.value &&
      currentGroup.name == createGroupForm.name.value &&
      currentGroup.level == createGroupForm.level.value &&
      currentGroup.subject['name'] == createGroupForm.subject['name']) {
    Snackbar.error('Not updating', 'No changes have been made');
    return;
  }

  if (createGroupForm.subject['name'] == '') {
    Snackbar.error('Subject selection', 'A subject needs to be selected');
    return;
  }

  if (!createGroupForm.isValidForm(formKey)) return;

  createGroupForm.isLoading.value = true;

  final group = Group(
      id: currentGroup.id,
      name: createGroupForm.name.trim().toTitleCase(),
      namedId: currentGroup.namedId,
      owner: currentGroup.owner,
      subject: {
        'name': createGroupForm.subject['name']!,
        'id': createGroupForm.subject['id']!
      },
      image: currentGroup.image,
      level: createGroupForm.level.value,
      members: currentGroup.members,
      activities: []);

  String? response;

  if (currentGroup.image == createGroupForm.selectedImage.value) {
    response = await groupController.updateGroupNoImage(group);
  } else {
    if (currentGroup.image == null &&
        createGroupForm.selectedImage.value != null) {
      print('no tengo y voy a agregar');
    } else if (currentGroup.image != null &&
        createGroupForm.selectedImage.value != null) {
      print('ya tengo y voy a cambiar');
    } else if (currentGroup.image != null &&
        createGroupForm.selectedImage.value == null) {
      print('ya tengo y voy a borrar');
    }
    //response = await groupController.updateGroupWithImage(group);
  }

/*final groupId = await groupController.createGroup(group);

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
*/

  if (response != null) {
    currentGroupController.currentGroup.value = group;
    currentGroupController.update();
    Snackbar.success('Group updated', 'Group information updated successfully');
  }

  createGroupForm.isLoading.value = false;
}
