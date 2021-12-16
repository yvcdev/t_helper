import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/models/models.dart';
import 'package:t_helper/screens/loading_screen.dart';
import 'package:t_helper/screens/login_screen.dart';
import 'package:t_helper/screens/personal_info_setup_screen.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/widgets/home_wrapper.dart';

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
            final userService = Provider.of<FBUserService>(context);
            return user == null
                ? const LoginScreen()
                : FutureBuilder(
                    future: userService.getUser(user),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return const LoadingScreen();

                      final user = snapshot.data as User;

                      userService.user = user;

                      if (user.firstName == null) {
                        return const PersonalInfoSetupScreen();
                      }

                      return const HomeWrapper();
                    });
          } else {
            return const LoadingScreen();
          }
        });
  }
}
