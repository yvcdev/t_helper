import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMemberFormController extends GetxController {
  String email = '';
  var isLoading = false.obs;

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    email = '';
    isLoading.value = false;
  }
}
