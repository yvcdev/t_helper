import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/screens/screens.dart';

import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/home_wrapper.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User?> fbUser = Rx(null);

  @override
  onReady() {
    super.onReady();
    fbUser = Rx<User?>(auth.currentUser);
    fbUser.bindStream(auth.userChanges());
  }

  Future login(String email, String password) async {
    const storage = FlutterSecureStorage();
    try {
      final result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      await storage.write(key: SKV.isAuthenticated, value: SKV.yes);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Snackbar.error(
            'Wrong credentials', 'Please check your credentials and try again');
        await storage.write(key: SKV.isAuthenticated, value: SKV.no);
      } else {
        Snackbar.error('Login error', 'Please try again later');
        await storage.write(key: SKV.isAuthenticated, value: SKV.no);
      }
    } catch (unknowError) {
      Snackbar.error('Login error', 'Please try again later');
      await storage.write(key: SKV.isAuthenticated, value: SKV.no);
    }
  }

  Future signup(String email, String password) async {
    const storage = FlutterSecureStorage();
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await storage.write(key: SKV.isAuthenticated, value: SKV.yes);
      return result;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Snackbar.error('Weak password', 'The password provided is too weak');
        await storage.write(key: SKV.isAuthenticated, value: SKV.no);
      } else if (e.code == 'email-already-in-use') {
        Snackbar.error(
            'Email in use', 'An account for that email already exists');
        await storage.write(key: SKV.isAuthenticated, value: SKV.no);
      } else {
        Snackbar.error(
            'Account creation failed', 'Your account could not be created');
        await storage.write(key: SKV.isAuthenticated, value: SKV.no);
      }
    } catch (unknowError) {
      Snackbar.error(
          'Account creation failed', 'Your account could not be created');
      await storage.write(key: SKV.isAuthenticated, value: SKV.no);
    }
  }

  Future<void> signOut() async {
    const storage = FlutterSecureStorage();
    await auth.signOut();

    await storage.write(key: SKV.isAuthenticated, value: SKV.no);
    await storage.write(key: SKV.hasData, value: SKV.no);

    Get.offAll(() => const LoginScreen());

    Get.delete<GroupController>();
  }

  verifyUserEmail() async {
    User? user = auth.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      await user.reload();
    }
  }

  Future<bool> updateEmail(String newEmail, String currentPassword,
      {bool onlyEmail = true}) async {
    try {
      final user = auth.currentUser;
      UserController userController = Get.find();

      if (onlyEmail) {
        await user!.reauthenticateWithCredential(EmailAuthProvider.credential(
            email: user.email!, password: currentPassword));
      }

      await user!.updateEmail(newEmail);

      await userController
          .updateUserInfo(userController.user.value!, {'email': newEmail});

      if (onlyEmail) {
        Snackbar.success('Success', 'Email updated');
      }

      Get.to(() => const VerifyEmailScreen());

      EditEmailPasswordFormController editEmailPasswordForm = Get.find();
      editEmailPasswordForm.reset();
      return true;
    } catch (e) {
      Snackbar.error('Error',
          'Either the password is incorrect or there is a server error');
      return true;
    }
  }

  Future<bool> updatePassword(String newPassword, String currentPassword,
      {bool onlyPassword = true}) async {
    try {
      final user = auth.currentUser;

      await user!.reauthenticateWithCredential(EmailAuthProvider.credential(
          email: user.email!, password: currentPassword));

      await user.updatePassword(newPassword);

      if (onlyPassword) {
        Snackbar.success('Success', 'Password updated');
      }

      if (auth.currentUser!.emailVerified) {
        Get.to(() => const HomeWrapper());
      } else {
        Get.to(() => const VerifyEmailScreen());
      }

      EditEmailPasswordFormController editEmailPasswordForm = Get.find();
      editEmailPasswordForm.reset();
      return true;
    } catch (e) {
      Snackbar.error('Error',
          'Either the password is incorrect or there is a server error');
      return false;
    }
  }

  Future updateEmailPassword(
      String newEmail, String newPassword, String currentPassword) async {
    final emailChanged =
        await updateEmail(newEmail, currentPassword, onlyEmail: false);
    final passwordChanged =
        await updatePassword(newPassword, currentPassword, onlyPassword: false);

    Get.to(() => const VerifyEmailScreen());

    EditEmailPasswordFormController editEmailPasswordForm = Get.find();
    editEmailPasswordForm.reset();

    if (emailChanged && passwordChanged) {
      Snackbar.success('Success', 'Email and Password updated');
    }
  }
}
