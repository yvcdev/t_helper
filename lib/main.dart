import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/activity_screens/activity_screens.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: const MyApp(),
      providers: [
        ChangeNotifierProvider(create: (_) => SentenceService()),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _themeData(context),
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: Routes.GROUP_ACTIVITIES,
      routes: {
        //Both
        Routes.LOGIN: (_) => const LoginScreen(),
        Routes.SIGNUP: (_) => const SignupScreen(),
        Routes.NOTIFICATIONS: (_) => const NotificationsScreen(),
        Routes.REGISTERED_GROUPS: (_) => const RegisteredGroupScreen(),
        Routes.GROUP_INFO: (_) => const GroupInfoScreen(),
        Routes.GROUP_MEMBERS: (_) => const GroupMembersScreen(),
        Routes.GROUP_ACTIVITIES: (_) => const GroupActivitiesScreen(),
        Routes.LOADING_SCREEN: (_) => const LoadingScreen(),

        //Teacher
        Routes.TEACHER_HOME: (_) => const TeacherHomeScreen(),
        Routes.CREATE_ACTIVITY: (_) => const CreateActivityScreen(),
        Routes.CREATE_GROUP: (_) => const CreateGroupScreen(),

        //Student
        Routes.ACTIVITY_SORT_SENTENCE: (_) => const ASortSentenceScreen(),
      },
    );
  }

  ThemeData _themeData(BuildContext context) {
    return ThemeData(
      canvasColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
          backgroundColor: CustomColors.appBar, centerTitle: true),
      textTheme: GoogleFonts.robotoTextTheme(
        Theme.of(context).textTheme.copyWith(
              subtitle1: const TextStyle(
                  color: CustomColors.almostBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              subtitle2:
                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14),
              headline3: const TextStyle(color: Colors.white, fontSize: 24),
            ),
      ),
      iconTheme: const IconThemeData(color: CustomColors.almostBlack),
    );
  }
}
