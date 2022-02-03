import 'package:get/get.dart';

import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/users_service.dart';

class UsersController extends GetxController {
  Rx<User?> student = Rx(null);
  Rx<String?> error = Rx(null);
  Rx<String?> message = Rx(null);
  var loading = true.obs;

  findUserByEmail(String email) async {
    final _user = await UsersService().findUserByEmail(email);
    student.value = _user;
  }

  reset() {
    error.value = null;
    message.value = null;
  }
}
