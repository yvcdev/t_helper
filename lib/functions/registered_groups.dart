import 'package:get/get.dart';
import 'package:t_helper/controllers/subject_controller.dart';
import 'package:t_helper/controllers/user_controller.dart';
import 'package:t_helper/screens/screens.dart';

registeredGroupsOnCreateGroupTap() async {
  SubjectController subjectController = Get.find();
  UserController userController = Get.find();
  final user = userController.user;

  final userId = user.value.uid;

  Get.to(() => CreateGroupScreen());

  await subjectController.getSubjects(userId);
}
