import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/services/fb_auth_service.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Student logout'),
          onPressed: () {
            final authService =
                Provider.of<FBAuthService>(context, listen: false);

            authService.signOut();
          },
        ),
      ),
    );
  }
}
