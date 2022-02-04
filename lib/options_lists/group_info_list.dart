import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/screens/screens.dart';

List<Map<String, dynamic>> groupInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.group,
      'color': Colors.orange,
      'text': 'Group members',
      'onTap': () async {
        final groupUsersController = Get.put(GroupUsersController());

        CurrentGroupController currentGroupController = Get.find();

        Get.to(() => GroupMembersScreen());

        await groupUsersController
            .getGroupUsers(currentGroupController.currentGroup.value!.id);
      },
    },
    {
      'icon': Icons.work,
      'color': Colors.cyan,
      'text': 'Group activities',
      'onTap': () {
        Get.to(() => const GroupActivitiesScreen());
      },
    },
    {
      'icon': Icons.add_reaction_sharp,
      'color': Colors.green,
      'text': 'Add activity',
      'onTap': () {
        Get.to(() => const GroupActivitiesScreen());
      },
    },
  ];
}
