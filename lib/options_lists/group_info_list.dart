import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/services/services.dart';

List<Map<String, dynamic>> groupInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.group,
      'color': Colors.orange,
      'text': 'Group members',
      'onTap': () async {
        final groupUsersService =
            Provider.of<FBGroupUsersService>(context, listen: false);
        final currentGroupProvider =
            Provider.of<CurrentGroupProvider>(context, listen: false);
        Get.to(() => GroupMembersScreen());

        await groupUsersService
            .getGroupUsers(currentGroupProvider.currentGroup!.id);
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
