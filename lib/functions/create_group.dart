import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

createGroupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  final createGroupForm =
      Provider.of<CreateGroupFormProvider>(context, listen: false);
  final groupService = Provider.of<FBGroupService>(context, listen: false);
  final userService = Provider.of<FBUserService>(context, listen: false);
  String? downloadUrl;

  if (createGroupForm.subject == '') {
    ScaffoldMessenger.of(context).showSnackBar(
        snackbar(message: 'A subject needs to be selected', success: false));
    return;
  }

  if (!createGroupForm.isValidForm(formKey)) return;

  createGroupForm.isLoading = true;

  final group = Group(
      id: '',
      name: createGroupForm.name.trim(),
      namedId: createGroupForm.groupId!,
      owner: userService.user.uid,
      subject: createGroupForm.subject,
      level: createGroupForm.level,
      members: 0,
      activities: []);

  final groupId = await groupService.createGroup(group);

  if (groupService.error != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(message: groupService.error!, success: false));
    createGroupForm.isLoading = false;
  } else {
    if (createGroupForm.selectedImage != null) {
      final groupStorageService =
          Provider.of<FBStorageGroup>(context, listen: false);

      downloadUrl = await groupStorageService.uploadGroupPicture(
          createGroupForm.selectedImage!, groupId!);

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

    final currentGroupProvider =
        Provider.of<CurrentGroupProvider>(context, listen: false);

    currentGroupProvider.currentGroup = group;

    Navigator.pushReplacementNamed(context, Routes.GROUP_INFO,
        arguments: group);
    createGroupForm.reset();
  }
}
