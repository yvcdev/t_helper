import 'package:flutter/material.dart';

import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/widgets/widgets.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
        title: 'Group infomation',
        child: Column(
          children: [
            Center(
              child: Text(
                'NaPower',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GroupInfoListTile(
              onTap: () {
                Navigator.pushNamed(context, 'group_members');
              },
              title: 'Group members',
            ),
          ],
        ));
  }
}
