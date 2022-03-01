import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';

import '../screens/personal_info_setup_screen.dart';
import '../utils/utils.dart';
import '../widgets/home_wrapper.dart';

signupOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();
  SignupFormController form = Get.find();
  AuthController auth = Get.find();

  UserController userController = Get.find();

  userController.reset();

  if (!form.isValid(formKey)) return;

  form.isLoading.value = true;

  final authUser = await auth.signup(form.email.toLowerCase(), form.password);

  if (authUser != null) {
    const storage = FlutterSecureStorage();
    await storage.write(key: SKV.isAuthenticated, value: SKV.yes);

    userController.streamUserInfo(authUser.user.uid, authUser.user.email);

    Get.offAll(() => const PersonalInfoSetupScreen());
  }

  form.isLoading.value = false;
}
