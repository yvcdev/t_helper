import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/widgets/home_wrapper.dart';
import 'firebase_options.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) {
    Get.put(AuthController());
    Get.put(UserController());
  });
  const storage = FlutterSecureStorage();

  final isAuthenticated = await storage.read(key: SKV.isAuthenticated);
  final hasData = await storage.read(key: SKV.hasData);

  bool startAtHome() {
    if (isAuthenticated == SKV.yes && hasData == SKV.yes) {
      return true;
    }
    return false;
  }

  AuthController authController = Get.find();
  if (authController.auth.currentUser != null) {
    UserController userController = Get.find();
    userController.streamUserInfo(authController.auth.currentUser!.uid,
        authController.auth.currentUser!.email!,
        navigate: false);

    await userController.populateUser(authController.auth.currentUser!.uid);
    await storage.write(key: SKV.isAuthenticated, value: SKV.yes);
    await storage.write(key: SKV.hasData, value: SKV.yes);
  }

  runApp(MyApp(
    startAtHome: startAtHome(),
  ));
}

class MyApp extends StatelessWidget {
  final bool startAtHome;

  const MyApp({Key? key, required this.startAtHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SubjectController(), fenix: true);
    Get.lazyPut(() => ActivitiesController(), fenix: true);
    Get.lazyPut(() => CurrentGroupController(), fenix: true);

    return GetMaterialApp(
      theme: _themeData(context),
      debugShowCheckedModeBanner: false,
      title: 'T Helper',
      home: startAtHome ? const HomeWrapper() : const LoginScreen(),
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
