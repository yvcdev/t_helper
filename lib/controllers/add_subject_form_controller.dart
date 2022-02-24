import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSubjectFormController extends GetxController {
  String subject = '';
  var isLoading = false.obs;

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    subject = '';
    isLoading.value = false;
  }
}
