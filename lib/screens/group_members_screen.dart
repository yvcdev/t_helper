import 'package:flutter/material.dart';
import 'package:t_helper/layouts/layouts.dart';

import 'package:t_helper/widgets/widgets.dart';

class GroupMembersScreen extends StatelessWidget {
  const GroupMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
      title: 'Group Members',
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return GroupInfoListTile(
            title: 'Student Name',
            subtitle: 'Student ID',
            image:
                'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?size=626&ext=jpg',
            onTap: () {
              print('$index');
            },
          );
        },
      ),
    );
  }
}
