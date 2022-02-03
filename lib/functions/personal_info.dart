import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/controllers.dart';

import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/services/services.dart';

personalInfoOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  UserController userController = Get.find();
  final user = userController.user;
  PersonalInfoFormController personalInfoForm = Get.find();

  String? downloadUrl;

  if (personalInfoForm.role.value == '') {
    Snackbar.error('Select role', 'A role needs to be selected');
    return;
  }
  if (!personalInfoForm.isValidForm(formKey)) return;

  personalInfoForm.isLoading.value = true;

  if (personalInfoForm.selectedImage.value != '') {
    downloadUrl = await StorageUserService.uploadProfilePicture(
        personalInfoForm.selectedImage.value, user.value.uid);

    if (downloadUrl == null) return;
  }

  User userToSend = User(
      email: user.value.email,
      uid: user.value.uid,
      firstName: personalInfoForm.firstName.toCapitalized(),
      middleName: personalInfoForm.middleName.value.toCapitalized(),
      lastName: personalInfoForm.lastName.toCapitalized(),
      preferredName: personalInfoForm.preferredName.value,
      role: personalInfoForm.role.value,
      profilePic: downloadUrl,
      groups: []);

  personalInfoForm.isLoading.value = true;

  await UserService.createUserInfo(userToSend);
}
