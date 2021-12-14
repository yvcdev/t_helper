import 'package:flutter/material.dart';
import 'package:t_helper/routes/routes.dart';

List<Map<String, dynamic>> teacherHomeInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.create,
      'color': Colors.cyan,
      'text': 'Create activity',
      'onTap': () {
        Navigator.pushNamed(context, Routes.CREATE_ACTIVITY);
      },
    },
    {
      'icon': Icons.group_add,
      'color': Colors.orange,
      'text': 'Create group',
      'onTap': () {
        Navigator.pushNamed(context, Routes.CREATE_GROUP);
      },
    }
  ];
}
