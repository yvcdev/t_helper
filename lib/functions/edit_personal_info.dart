import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/controllers/edit_info_form_controller.dart';
import 'package:t_helper/controllers/user_controller.dart';

editPersonalInfoOnUpdate(
    GlobalKey<FormState> editInfoFormKey, BuildContext context) async {
  EditInfoFormController editInfoForm = Get.find();
  UserController userController = Get.find();
  Map<String, dynamic> _updateInfo = {};
  Map _fieldMap = {
    'firstName': editInfoForm.firstName.value.toCapitalized(),
    'middleName': editInfoForm.middleName.value.toCapitalized(),
    'lastName': editInfoForm.lastName.value.toCapitalized(),
    'preferredName': editInfoForm.preferredName.value,
  };

  if (!editInfoForm.isValidForm(editInfoFormKey)) return;
  FocusScope.of(context).unfocus();

  editInfoForm.isLoading.value = true;

  editInfoForm.fields.forEach((key, value) {
    if (value) {
      if (key == 'profilePic') {
        _updateInfo['profilePic'] = editInfoForm.selectedImage.value;
      } else {
        _updateInfo[key] = _fieldMap[key];
      }
    }
  });

  await userController.updateUserInfo(userController.user.value!, _updateInfo);
  editInfoForm.isSaved.value = true;

  editInfoForm.isLoading.value = false;
}
