import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import 'package:t_helper/controllers/controllers.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Student logout'),
          onPressed: () {
            AuthController authController = Get.find();

            authController.signOut();
          },
        ),
      ),
    );
  }
}
