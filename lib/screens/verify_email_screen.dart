import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/widgets/widgets.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    UserController userController = Get.find();
    final verifyEmailController = Get.put(VerifyEmailController());

    return DefaultAppBarLayout(
        title: 'Verification',
        appBarBottomHeight: 80,
        appBarBottom: const _AppBarBottom(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 150,
                  child: Image.asset('assets/email_verification.png'),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Verification email sent to ${userController.user.value.email}',
                  style: const TextStyle(
                      fontSize: UiConsts.normalFontSize,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Please check your inbox for the verification email. Open the link there, come back to the app, and click the button bellow.',
                  style: TextStyle(
                    fontSize: UiConsts.normalFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => RequestButton(
                    isLoading: verifyEmailController.isLoadingVerify.value,
                    onTap: () async {
                      await authController.auth.currentUser!.reload();
                    },
                    waitTitle: 'Please wait',
                    title: 'Already Verified My Email')),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => RequestButton(
                    isActive: verifyEmailController.allowResendEmail.value,
                    isLoading: verifyEmailController.isLoadingSend.value,
                    onTap: () async {
                      await authController.auth.currentUser!
                          .sendEmailVerification();
                      verifyEmailController.startTimer();
                      verifyEmailController.allowResendEmail.value = false;
                    },
                    waitTitle: 'Please wait',
                    title: 'Send Email Again')),
                const SizedBox(
                  height: 5,
                ),
                Obx(() => Visibility(
                      visible: !verifyEmailController.allowResendEmail.value,
                      child: Text(
                        '${verifyEmailController.minutes.value}: ${verifyEmailController.seconds.value < 10 ? '0' : ''}${verifyEmailController.seconds.value}',
                        style: const TextStyle(
                            fontSize: UiConsts.smallFontSize,
                            color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                CustomTextButton(
                    onPressed: () {
                      Get.to(() => const EditEmailPasswordScreen());
                    },
                    title: 'Change Email'),
              ],
            ),
          ),
        ]);
  }
}

class _AppBarBottom extends StatelessWidget {
  const _AppBarBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    final user = userController.user;

    return Column(
      children: [
        const Text(
          'Hello',
          style: TextStyle(
              color: Colors.white, fontSize: UiConsts.normalFontSize - 4),
        ),
        Obx(() => Text(
              user.value.preferredName == 'firstName'
                  ? user.value.firstName!
                  : user.value.middleName!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: UiConsts.normalFontSize,
                  fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
