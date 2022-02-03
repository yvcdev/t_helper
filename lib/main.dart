import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'firebase_options.dart';

import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthController(), permanent: true));
  Get.put(CurrentGroupController());
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
        ChangeNotifierProvider(create: (_) => SentenceService()),
        ChangeNotifierProvider(create: (_) => FBGroupService()),
        ChangeNotifierProvider(create: (_) => FBSubjectService()),
        ChangeNotifierProvider(create: (_) => FBActivitiesService()),
        Provider<FBStorageUser>(create: (_) => FBStorageUser()),
        Provider<FBStorageGroup>(create: (_) => FBStorageGroup()),
        Provider<FBAuthService>(create: (_) => FBAuthService()),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _themeData(context),
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const LoginScreen(),
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
