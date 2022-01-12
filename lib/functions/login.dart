import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/fb_auth_service.dart';
import 'package:t_helper/utils/utils.dart';

loginOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  final loginForm = Provider.of<LoginFormProvider>(context, listen: false);
  final authService = Provider.of<FBAuthService>(context, listen: false);

  if (!loginForm.isValidForm(formKey)) return;

  loginForm.isLoading = true;

  await authService.login(loginForm.email, loginForm.password);

  if (authService.error != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(message: authService.error!, success: false));
    loginForm.isLoading = false;
  } else {
    loginForm.reset();
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }
}
