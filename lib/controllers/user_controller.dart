import 'package:get/get.dart';
import 'package:t_helper/controllers/auth_controller.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/services.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  final _authUser = AuthController.instance.fbUser.value;
  Rx<User> user = User(email: '', uid: '').obs;

  @override
  void onInit() {
    user.bindStream(UserService().getUser(_authUser!.uid));
    super.onInit();
  }
}
