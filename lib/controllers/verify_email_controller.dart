import 'dart:async';

import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';

class VerifyEmailController extends GetxController {
  AuthController authController = Get.find();
  var allowResendEmail = true.obs;
  var isLoadingVerify = false.obs;
  var isLoadingSend = false.obs;
  var minutes = 2.obs;
  var seconds = 0.obs;

  startTimer() {
    minutes.value = 2;
    seconds.value = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (minutes.value == 0 && seconds.value == 0) {
        timer.cancel();
        allowResendEmail.value = true;
        return;
      }
      if (seconds.value == 0) {
        seconds.value = 60;
        minutes.value--;
      }
      seconds.value--;
    });
  }

  checkVerificationState() async {
    try {
      isLoadingVerify.value = true;
      await authController.auth.currentUser!.reload();
      isLoadingVerify.value = false;
    } catch (e) {
      isLoadingVerify.value = false;
      Snackbar.error('Verification error', 'Error trying to verify the email');
    }
  }

  sendVerificationEmail() async {
    try {
      isLoadingSend.value = true;
      await authController.auth.currentUser!.sendEmailVerification();
      isLoadingSend.value = false;
    } catch (e) {
      isLoadingSend.value = false;
      Snackbar.error('Verification error', 'Error trying to verify the email');
    }
  }
}
