import 'package:flutter/material.dart';

import 'package:t_helper/screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'teacher_home',
      routes: {
        'teacher_home': (_) => const TeacherHomeScreen(),
        'login': (_) => const LoginScreen(),
      },
    );
  }
}
