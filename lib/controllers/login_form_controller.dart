import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFormController extends GetxController {
  static LoginFormController instance = Get.find();
  var email = '';
  var password = '';
  var isLoading = false.obs;

  bool isValid(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    email = '';
    password = '';
    isLoading.value = false;
  }
}
