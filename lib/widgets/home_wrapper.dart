import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/controllers/user_controller.dart';

import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserController.instance.user.value;

    switch (user.role) {
      case 'teacher':
        return const TeacherHomeScreen();
      case 'student':
        return const StudentHomeScreen();
      default:
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
                      final authService =
                          Provider.of<FBAuthService>(context, listen: false);
                      authService.signOut();
                    },
                    child: const Text('Sign Out'))
              ],
            ),
          ),
        );
    }
  }
}
