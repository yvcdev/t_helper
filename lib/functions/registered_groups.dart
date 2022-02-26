import 'package:get/get.dart';
import 'package:t_helper/controllers/create_group_form_controller.dart';
import 'package:t_helper/controllers/subject_controller.dart';
import 'package:t_helper/controllers/user_controller.dart';
import 'package:t_helper/screens/screens.dart';

registeredGroupsOnCreateGroupTap() async {
  SubjectController subjectController = Get.find();
  UserController userController = Get.find();
  final user = userController.user;

  final userId = user.value!.uid;

  if (Get.isRegistered<CreateGroupFormController>()) {
    CreateGroupFormController createGroupFormController = Get.find();
    createGroupFormController.reset();
  }

  Get.to(() => CreateGroupScreen());

  await subjectController.getSubjects(userId);
}
