import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/custom_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _themeData(context),
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'teacher_home',
      routes: {
        'teacher_home': (_) => const TeacherHomeScreen(),
        'login': (_) => const LoginScreen(),
      },
    );
  }

  ThemeData _themeData(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
          backgroundColor: CustomColors.primary, centerTitle: true),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme.copyWith(
              subtitle1: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              subtitle2:
                  TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
            ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
