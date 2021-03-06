import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/screens/screens.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    final user = userController.user;
    AuthController authController = Get.find();

    if (user.value!.role == 'teacher') {
      if (!authController.auth.currentUser!.emailVerified) {
        return const VerifyEmailScreen();
      }
      return const TeacherHomeScreen();
    } else if (user.value!.role == 'student') {
      if (!authController.auth.currentUser!.emailVerified) {
        return const VerifyEmailScreen();
      }
      return const StudentHomeScreen();
    } else {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Invalid role'),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    authController.signOut();
                  },
                  child: const Text('Sign Out'))
            ],
          ),
        ),
      );
    }
    //}
    //);
  }
}
