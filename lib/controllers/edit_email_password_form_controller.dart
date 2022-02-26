import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/user_controller.dart';

class EditEmailPasswordFormController extends GetxController {
  Rx<String> newEmail = ''.obs;
  Rx<String> currentPassword = ''.obs;
  Rx<String> newPassword = ''.obs;
  Rx<String> confirmPassword = ''.obs;
  Rx<String> updateButtonText = 'Update'.obs;
  var isLoading = false.obs;
  var isSaved = true.obs;
  UserController userController = Get.find();
  Map<String, bool> fields = {
    'email': false,
    'currentPassword': false,
    'password': false,
    'confirmPassword': false,
  };
  var toUpdate = ''.obs;

  @override
  onReady() {
    super.onReady();
    ever(
        newEmail,
        (value) =>
            updateIsSaved('email', value, userController.user.value!.email));
    ever(newPassword,
        (value) => updateIsSaved('password', newPassword.value, value));
    ever(
        currentPassword,
        (value) =>
            updateIsSaved('currentPassword', currentPassword.value, value));
    ever(
        confirmPassword,
        (value) =>
            updateIsSaved('confirmPassword', confirmPassword.value, value));
  }

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  updateIsSaved(String field, formValue, userValue) {
    if (field == 'email') {
      if (formValue.toString().toLowerCase() != userValue &&
          formValue.trim() != '') {
        fields[field] = true;
      } else {
        fields[field] = false;
      }
    } else {
      if (formValue.toString().trim() == '') {
        fields[field] = false;
      } else {
        fields[field] = true;
      }
    }

    if (fields.containsValue(true)) {
      isSaved.value = false;
    } else {
      isSaved.value = true;
    }

    changeTextInUpdateButton(field);
  }

  changeTextInUpdateButton(String field) {
    bool _email = false;
    bool _password = false;

    fields.forEach((key, active) {
      if (key == "email" && active) {
        _email = true;
      } else if (key == "password" && active) {
        _password = true;
      } else if (key == "confirmPassword" && active) {
        _password = true;
      }
    });

    if (_email && _password) {
      updateButtonText.value = "Update Both";
      toUpdate.value = 'both';
    } else if (_password) {
      updateButtonText.value = "Update Password";
      toUpdate.value = 'password';
    } else if (_email) {
      updateButtonText.value = "Update Email";
      toUpdate.value = 'email';
    } else {
      updateButtonText.value = "Update";
      toUpdate.value = '';
    }
  }

  void reset() {
    newEmail.value = '';
    newPassword.value = '';
    currentPassword.value = '';
    confirmPassword.value = '';
    isLoading.value = false;
  }
}
