import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

editEmailPasswordOnUpdate(
    GlobalKey<FormState> editEmailPassword, BuildContext context) async {
  EditEmailPasswordFormController editEmailPasswordForm = Get.find();
  UserController userController = Get.find();
  Map<String, dynamic> _updateInfo = {};
  Map _fieldMap = {
    'email': editEmailPasswordForm.newEmail.value,
    'password': editEmailPasswordForm.newPassword.value,
  };

  if (!editEmailPasswordForm.isValidForm(editEmailPassword)) return;
  FocusScope.of(context).unfocus();

  editEmailPasswordForm.isLoading.value = true;

  return;

  editEmailPasswordForm.fields.forEach((key, value) {
    if (value) {
      if (key == 'password') {
        //_updateInfo['password'] = editEmailPasswordForm.newPassword.value;
      } else {
        //_updateInfo[key] = _fieldMap[key];
      }
    }
  });

  await userController.updateUserInfo(userController.user.value, _updateInfo);
  editEmailPasswordForm.isSaved.value = true;

  editEmailPasswordForm.isLoading.value = false;
}

editEmailPasswordShowDialog(
    GlobalKey<FormState> editEmailPasswordFormKey, BuildContext context) {
  EditEmailPasswordFormController editEmailPasswordForm = Get.find();
  if (editEmailPasswordForm.isValidForm(editEmailPasswordFormKey)) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => MinimalPopUp(
              topImage: false,
              correctText: 'Please confirm you want to change ' +
                  (editEmailPasswordForm.toUpdate == 'both'
                      ? 'your email and password'
                      : editEmailPasswordForm.toUpdate == 'email'
                          ? 'your email'
                          : 'your password'),
              description:
                  'If the email is change, you would have to verify the new one in order to access your account',
              acceptButtonLabel: 'Confirm',
              cancelButtonLabel: 'Cancel',
              isAcceptActive: true,
              isCancelActive: true,
              acceptButtonColor: CustomColors.green,
              cancelButtonColor: CustomColors.red,
              onAccept: () => print('implement'),
              onCancel: () => Get.back(),
            ));
  }
}
