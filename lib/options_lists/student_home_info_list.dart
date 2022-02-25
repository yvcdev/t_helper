import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';

import 'package:t_helper/screens/screens.dart';

List<Map<String, dynamic>> studentHomeInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.group,
      'text': 'Your groups',
      'onTap': () async {},
    },
    {
      'icon': Icons.add_box_rounded,
      'text': 'Pending activities',
      'onTap': () async {},
    },
    {
      'icon': Icons.group_add,
      'text': 'Your activities',
      'onTap': () {},
    },
    {
      'icon': Icons.group_add,
      'text': 'Grades',
      'onTap': () async {},
    },
  ];
}
