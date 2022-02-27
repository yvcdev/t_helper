import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';

import 'package:t_helper/screens/screens.dart';

List<Map<String, dynamic>> teacherHomeInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.create,
      'text': 'Subjects',
      'onTap': () async {
        SubjectController subjectController = Get.find();
        UserController userController = Get.find();
        final user = userController.user;

        final userId = user.value!.uid;

        Get.to(() => const SubjectsScreen());

        await subjectController.getSubjects(userId);
      },
    },
    {
      'icon': Icons.add_box_rounded,
      'text': 'Set up activity',
      'onTap': () async {
        ActivitiesController activitiesController = Get.find();

        Get.to(() => const SetUpActivityScreen());

        await activitiesController.getActivities();
      },
    },
    {
      'icon': Icons.add_to_photos_rounded,
      'text': 'Your activities',
      'onTap': () {},
    },
    {
      'icon': Icons.group_add,
      'text': 'Create group',
      'onTap': () async {
        SubjectController subjectController = Get.find();

        UserController userController = Get.find();
        final user = userController.user;

        final userId = user.value!.uid;
        await subjectController.getSubjects(userId, onlyActive: true);

        if (Get.isRegistered<CreateGroupFormController>()) {
          CreateGroupFormController createGroupFormController = Get.find();
          createGroupFormController.reset();
        }

        Get.to(() => CreateGroupScreen());
      },
    },
  ];
}
