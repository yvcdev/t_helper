import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

editEmailPasswordOnUpdate(
    GlobalKey<FormState> editEmailPassword, BuildContext context) async {
  EditEmailPasswordFormController editEmailPasswordForm = Get.find();
  AuthController authController = Get.find();
  Map _fieldMap = {
    'email': editEmailPasswordForm.newEmail.value,
    'password': editEmailPasswordForm.newPassword.value,
    'currentPassword': editEmailPasswordForm.currentPassword.value,
  };

  if (!editEmailPasswordForm.isValidForm(editEmailPassword)) return;
  FocusScope.of(context).unfocus();

  editEmailPasswordForm.isLoading.value = true;

  switch (editEmailPasswordForm.toUpdate.value) {
    case 'email':
      if (!Get.isRegistered<GroupUsersController>()) {
        Get.lazyPut(() => GroupUsersController());
      }
      GroupUsersController groupUsersController = Get.find();
      UserController userController = Get.find();
      final _user = userController.user.value;

      final newUser = User(
          email: _fieldMap['email'],
          uid: _user!.uid,
          firstName: _user.firstName,
          middleName: _user.middleName,
          lastName: _user.lastName,
          profilePic: _user.profilePic);

      await groupUsersController.updateUserInfo(newUser);
      await authController.updateEmail(
          _fieldMap['email'], _fieldMap['currentPassword']);
      break;
    case 'password':
      await authController.updatePassword(
          _fieldMap['password'], _fieldMap['currentPassword']);
      break;
    case 'both':
      if (!Get.isRegistered<GroupUsersController>()) {
        Get.lazyPut(() => GroupUsersController());
      }
      GroupUsersController groupUsersController = Get.find();
      UserController userController = Get.find();
      final _user = userController.user.value;

      final newUser = User(
          email: _fieldMap['email'],
          uid: _user!.uid,
          firstName: _user.firstName,
          middleName: _user.middleName,
          lastName: _user.lastName,
          profilePic: _user.profilePic);

      await groupUsersController.updateUserInfo(newUser);
      await authController.updateEmailPassword(_fieldMap['email'],
          _fieldMap['password'], _fieldMap['currentPassword']);
      break;
  }

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
                  (editEmailPasswordForm.toUpdate.value == 'both'
                      ? 'your email and password'
                      : editEmailPasswordForm.toUpdate.value == 'email'
                          ? 'your email'
                          : 'your password'),
              description: editEmailPasswordForm.toUpdate.value != 'password'
                  ? 'A new email verification process will be necessary if the email is changed'
                  : null,
              acceptButtonLabel: 'Confirm',
              cancelButtonLabel: 'Cancel',
              isAcceptActive: true,
              isCancelActive: true,
              acceptButtonColor: CustomColors.green,
              cancelButtonColor: CustomColors.red,
              onAccept: () {
                Get.back();
                editEmailPasswordOnUpdate(editEmailPasswordFormKey, context);
              },
              onCancel: () => Get.back(),
            ));
  }
}
