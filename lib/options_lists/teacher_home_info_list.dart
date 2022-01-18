import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';

List<Map<String, dynamic>> teacherHomeInfoList(BuildContext context) {
  return [
    {
      'icon': Icons.create,
      'text': 'Subjects',
      'onTap': () async {
        final subjectService =
            Provider.of<FBSubjectService>(context, listen: false);
        final userService = Provider.of<FBUserService>(context, listen: false);

        final userId = userService.user.uid;

        Navigator.pushNamed(context, Routes.CREATE_SUBJECT);

        await subjectService.getSubjects(userId);
      },
    },
    {
      'icon': Icons.add_box_rounded,
      'text': 'Set up activity',
      'onTap': () async {
        final activitiesService =
            Provider.of<FBActivitiesService>(context, listen: false);

        Navigator.pushNamed(context, Routes.CREATE_ACTIVITY);

        await activitiesService.getActivities();
      },
    },
    {
      'icon': Icons.group_add,
      'text': 'Your activities',
      'onTap': () {},
    },
    {
      'icon': Icons.group_add,
      'text': 'Create group',
      'onTap': () async {
        final subjectService =
            Provider.of<FBSubjectService>(context, listen: false);
        final userService = Provider.of<FBUserService>(context, listen: false);

        final userId = userService.user.uid;
        await subjectService.getSubjects(userId, onlyActive: true);
        Navigator.pushNamed(context, Routes.CREATE_GROUP);
      },
    },
  ];
}
