import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupFormController extends GetxController {
  var email = '';
  var password = '';
  var confirmPassword = '';
  var isLoading = false.obs;

  bool isValid(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    email = '';
    password = '';
    confirmPassword = '';
    isLoading.value = false;
  }
}
