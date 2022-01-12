import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/fb_auth_service.dart';
import 'package:t_helper/utils/utils.dart';

signupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  final authService = Provider.of<FBAuthService>(context, listen: false);
  final signupForm = Provider.of<SignupFormProvider>(context, listen: false);

  if (!signupForm.isValidForm(formKey)) return;

  signupForm.isLoading = true;

  await authService.signup(signupForm.email.toLowerCase(), signupForm.password);

  if (authService.error != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(message: authService.error!, success: false));
    signupForm.isLoading = false;
  } else {
    signupForm.reset();
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }
}
