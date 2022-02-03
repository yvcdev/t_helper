import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateGroupFormController extends GetxController {
  var name = ''.obs;
  String? groupId;
  Rx<String?> selectedImage = Rx(null);
  Rx<File?> newPictureFile = Rx(null);
  var subject = {'name': '', 'id': ''}.obs;
  var level = 'beginner'.obs;
  var isLoading = false.obs;

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    name.value = '';
    groupId = null;
    subject.value = {'name': '', 'id': ''};
    selectedImage.value = null;
    newPictureFile.value = null;
    level.value = 'beginner';
    isLoading.value = false;
  }

  void setSelectedImage(String? path) {
    selectedImage.value = path;
    newPictureFile.value = File.fromUri(Uri(path: path));
  }

  String getGroupId() {
    List<String> _formattedNameList = name.trim().split(' ');
    String _formattedName = _formattedNameList.join('-').toLowerCase();
    if (_formattedName.length > 25) {
      groupId = _formattedName.substring(0, 24);
    } else {
      groupId = _formattedName;
    }
    return groupId ?? '';
  }
}
