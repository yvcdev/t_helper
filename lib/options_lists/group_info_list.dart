import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/fb_users_service.dart';

List<Map<String, dynamic>> groupInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.group,
      'color': Colors.orange,
      'text': 'Group members',
      'onTap': () {
        Navigator.pushNamed(context, Routes.GROUP_MEMBERS);
        final usersService =
            Provider.of<FBUsersService>(context, listen: false);
        final currentGroupProvider =
            Provider.of<CurrentGroupProvider>(context, listen: false);

        usersService.getUsersInGroup(currentGroupProvider.currentGroup!.id);
      },
    },
    {
      'icon': Icons.work,
      'color': Colors.cyan,
      'text': 'Group activities',
      'onTap': () {
        Navigator.pushNamed(context, Routes.GROUP_ACTIVITIES);
      },
    },
    {
      'icon': Icons.add_reaction_sharp,
      'color': Colors.green,
      'text': 'Add activity',
      'onTap': () {
        Navigator.pushNamed(context, Routes.GROUP_ACTIVITIES);
      },
    },
    {
      'icon': Icons.person_add_alt_1_rounded,
      'color': Colors.purple,
      'text': 'Add member',
      'onTap': () {
        Navigator.pushNamed(context, Routes.ADD_MEMBER);
      },
    },
  ];
}
