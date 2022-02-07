import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:t_helper/controllers/user_controller.dart';

class EditInfoFormController extends GetxController {
  Rx<String> selectedImage = ''.obs;
  File? newPictureFile;
  Rx<String> firstName = ''.obs;
  Rx<String> lastName = ''.obs;
  var middleName = ''.obs;
  var isLoading = false.obs;
  var preferredName = 'firstName'.obs;
  var isSaved = true.obs;
  UserController userController = Get.find();
  Map<String, bool> fields = {
    'selectedImage': false,
    'firstName': false,
    'lastName': false,
    'middleName': false,
    'preferredName': false,
  };

  @override
  void onInit() {
    super.onInit();
    populate();
  }

  @override
  onReady() {
    super.onReady();
    ever(
        firstName,
        (value) => updateIsSaved(
            'firstName', value, userController.user.value.firstName));
    ever(
        middleName,
        (value) => updateIsSaved(
            'middleName', value, userController.user.value.middleName));
    ever(
        lastName,
        (value) => updateIsSaved(
            'lastName', value, userController.user.value.lastName));
    ever(
        selectedImage,
        (value) => updateIsSaved(
            'selectedImage', value, userController.user.value.profilePic));
    ever(
        preferredName,
        (value) => updateIsSaved(
            'preferredName', value, userController.user.value.preferredName));
  }

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  updateIsSaved(String field, formValue, userValue) {
    if (formValue != userValue) {
      fields[field] = true;
    } else {
      fields[field] = false;
    }

    if (fields.containsValue(true)) {
      isSaved.value = false;
    } else {
      isSaved.value = true;
    }
  }

  void reset() {
    firstName.value = '';
    lastName.value = '';
    middleName.value = '';
    preferredName.value = 'firstName';
    selectedImage.value = '';
    newPictureFile = null;
    isLoading.value = false;
  }

  void populate() {
    final user = userController.user;

    firstName.value = user.value.firstName!;
    middleName.value = user.value.middleName ?? '';
    lastName.value = user.value.lastName!;
    preferredName.value = user.value.preferredName!;
    selectedImage.value = user.value.profilePic ?? '';
  }

  void setSelectedImage(String path) {
    selectedImage.value = path;
    newPictureFile = File.fromUri(Uri(path: path));
  }
}
