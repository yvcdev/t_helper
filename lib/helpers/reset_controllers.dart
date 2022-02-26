import 'package:get/instance_manager.dart';
import 'package:t_helper/controllers/controllers.dart';

resetControllers() {
  UserController userController = Get.find();
  GroupController groupController = Get.find();
  userController.reset();
  groupController.reset();
}
