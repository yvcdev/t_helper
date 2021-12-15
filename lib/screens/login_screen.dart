import 'package:flutter/material.dart';

import 'package:t_helper/layouts/auth_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthLayout(login: true);
  }
}
