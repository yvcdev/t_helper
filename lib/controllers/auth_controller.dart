import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';

import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/widgets/home_wrapper.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> fbUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  onReady() {
    super.onReady();
    fbUser = Rx<User?>(_auth.currentUser);
    fbUser.bindStream(_auth.userChanges());
    Get.put(UserController());
    ever(fbUser, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const HomeWrapper());
    }
  }

  login(String email, String password) {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
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

  signup(String email, String password) {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
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
}
