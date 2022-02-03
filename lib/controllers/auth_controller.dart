import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/user_service.dart';
import 'package:t_helper/widgets/home_wrapper.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> fbUser;

  @override
  onReady() {
    super.onReady();
    fbUser = Rx<User?>(_auth.currentUser);
    fbUser.bindStream(_auth.userChanges());
    Get.put(UserController(), permanent: true);
    ever(fbUser, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const HomeWrapper());
    }
  }

  Future login(String email, String password) async {
    try {
      UserController userController = Get.find();

      final authUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final _user = await UserService().getUserMAnually(authUser.user!.uid);

      userController.onLogin();
      userController.user.value = _user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Snackbar.error(
            'Wrong credentials', 'Please check your credentials and try again');
      } else {
        Snackbar.error('Login error', 'Please try again later');
      }
    } catch (unknowError) {
      Snackbar.error('Login error', 'Please try again later');
    }
  }

  Future signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Snackbar.error('Weak password', 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        Snackbar.error(
            'Email in use', 'An account for that email already exists');
      } else {
        Snackbar.error(
            'Account creation failed', 'Your account could not be created');
      }
    } catch (unknowError) {
      Snackbar.error(
          'Account creation failed', 'Your account could not be created');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    UserController userController = Get.find();
    userController.reset();
  }
}