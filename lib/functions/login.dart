import 'package:flutter/material.dart';
import 'package:t_helper/controllers/controllers.dart';

loginOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  final form = LoginFormController.instance;
  final auth = AuthController.instance;

  if (!form.isValid(formKey)) return;

  form.isLoading.value = true;

  await auth.login(form.email, form.password);
}
