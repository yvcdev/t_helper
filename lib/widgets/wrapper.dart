import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/screens/loading_screen.dart';
import 'package:t_helper/screens/login_screen.dart';
import 'package:t_helper/screens/teacher_home_screen.dart';

import 'package:t_helper/services/fb_auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<FBAuthService>(context);

    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            return user == null
                ? const LoginScreen()
                : const TeacherHomeScreen();
          } else {
            return const LoadingScreen();
          }
        });
  }
}
