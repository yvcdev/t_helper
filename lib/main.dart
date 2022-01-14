import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/widgets/wrapper.dart';
import 'package:t_helper/activity_screens/activity_screens.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: const MyApp(),
      providers: [
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => SignupFormProvider()),
        ChangeNotifierProvider(create: (_) => PersonalInfoFormProvider()),
        ChangeNotifierProvider(create: (_) => CreateGroupFormProvider()),
        ChangeNotifierProvider(create: (_) => AddMemberFormProvider()),
        ChangeNotifierProvider(create: (_) => AddSubjectFormProvider()),
        ChangeNotifierProvider(create: (_) => SentenceService()),
        ChangeNotifierProvider(create: (_) => FBUsersService()),
        ChangeNotifierProvider(create: (_) => FBGroupUsersService()),
        ChangeNotifierProvider(create: (_) => CurrentGroupProvider()),
        ChangeNotifierProvider(create: (_) => FBGroupService()),
        ChangeNotifierProvider(create: (_) => FBSubjectService()),
        Provider<FBStorageUser>(create: (_) => FBStorageUser()),
        Provider<FBStorageGroup>(create: (_) => FBStorageGroup()),
        Provider<FBAuthService>(create: (_) => FBAuthService()),
        Provider<FBUserService>(create: (_) => FBUserService()),
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
      initialRoute: Routes.HOME,
      routes: {
        //Both
        Routes.LOGIN: (_) => const LoginScreen(),
        Routes.SIGNUP: (_) => const SignupScreen(),
        Routes.NOTIFICATIONS: (_) => const NotificationsScreen(),
        Routes.REGISTERED_GROUPS: (_) => const RegisteredGroupScreen(),
        Routes.GROUP_INFO: (_) => const GroupInfoScreen(),
        Routes.GROUP_MEMBERS: (_) => GroupMembersScreen(),
        Routes.GROUP_ACTIVITIES: (_) => const GroupActivitiesScreen(),
        Routes.LOADING: (_) => const LoadingScreen(),
        Routes.FINISHED: (_) => const FinishedScreen(),
        Routes.HOME: (_) => const Wrapper(),

        //Teacher
        Routes.TEACHER_HOME: (_) => const Wrapper(),
        Routes.CREATE_ACTIVITY: (_) => const CreateActivityScreen(),
        Routes.CREATE_GROUP: (_) => const CreateGroupScreen(),
        Routes.CREATE_SUBJECT: (_) => const SubjectsScreen(),

        //Student
        Routes.ACTIVITY_SORT_SENTENCE: (_) => const ASortSentenceScreen(),
        Routes.STUDENT_HOME: (_) => const Wrapper(),
      },
    );
  }

  ThemeData _themeData(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: CustomColors.appBar,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: UiConsts.normalFontSize,
        ),
      ),
      textTheme: GoogleFonts.openSansTextTheme(
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
