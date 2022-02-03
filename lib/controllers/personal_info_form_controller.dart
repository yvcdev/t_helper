import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class PersonalInfoFormController extends GetxController {
  Rx<String> selectedImage = ''.obs;
  File? newPictureFile;
  String firstName = '';
  String lastName = '';
  var middleName = ''.obs;
  var isLoading = false.obs;
  var role = ''.obs;
  var preferredName = 'firstName'.obs;

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    firstName = '';
    lastName = '';
    middleName.value = '';
    preferredName.value = 'firstName';
    role.value = '';
    selectedImage.value = '';
    newPictureFile = null;
    isLoading.value = false;
  }

  void setSelectedImage(String path) {
    selectedImage.value = path;
    newPictureFile = File.fromUri(Uri(path: path));
  }
}
