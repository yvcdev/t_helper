import 'package:flutter/material.dart';

List<Map<String, dynamic>> studentHomeInfoList(BuildContext context) {
  return [
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
    {
      'icon': Icons.checklist_rounded,
      'text': 'Attendance',
      'onTap': () async {},
    }
  ];
}
