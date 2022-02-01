import 'package:flutter/material.dart';
import 'package:t_helper/controllers/controllers.dart';

signupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  final form = SignupFormController.instance;
  final auth = AuthController.instance;

  if (!form.isValid(formKey)) return;

  form.isLoading.value = true;

  await auth.signup(form.email.toLowerCase(), form.password);
}
