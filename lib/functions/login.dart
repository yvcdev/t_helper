import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/controllers.dart';

loginOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  LoginFormController form = Get.find();
  AuthController auth = Get.find();

  if (!form.isValid(formKey)) return;

  form.isLoading.value = true;

  await auth.login(form.email, form.password);

  form.isLoading.value = false;
}
