import 'package:get/get.dart';
import 'package:t_helper/controllers/auth_controller.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/services.dart';

class UserController extends GetxController {
  AuthController authController = Get.find();
  Rx<User> user = User(email: '', uid: '').obs;

  @override
  void onInit() {
    final authUser = authController.fbUser;
    user.bindStream(
        UserService().getUser(authUser.value!.uid, authUser.value!.email!));
    super.onInit();
  }

  void onAuth() {
    final authUser = authController.fbUser;
    user.bindStream(
        UserService().getUser(authUser.value!.uid, authUser.value!.email!));
  }

  reset() {
    user.value = User(email: '', uid: '');
  }
}
