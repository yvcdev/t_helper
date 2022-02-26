import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/storage_keys_values.dart';

class UserController extends GetxController {
  Rx<User?> user = Rx(null);

  streamUserInfo(String uid, String email, {navigate = true}) {
    user.bindStream(UserService().getUser(uid, email, navigate: navigate));

    ever(user, (_user) async {
      const storage = FlutterSecureStorage();
      if (_user == null) {
        await storage.write(key: SKV.hasData, value: SKV.no);
      } else {
        await storage.write(key: SKV.hasData, value: SKV.yes);
      }
    });
  }

  populateUser(uid) async {
    user.value = await UserService().populateUser(uid);
  }

  reset() {
    user.value = User(email: '', uid: '');
  }

  Future updateUserInfo(User user, Map<String, dynamic> updateInfo) async {
    await UserService().updateUserInfo(user, updateInfo);
  }
}
