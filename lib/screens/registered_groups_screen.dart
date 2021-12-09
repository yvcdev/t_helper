import 'package:flutter/material.dart';
import 'package:t_helper/layouts/layouts.dart';

import 'package:t_helper/widgets/widgets.dart';

class RegisteredGroupScreen extends StatelessWidget {
  const RegisteredGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
      title: 'Your Groups',
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return GroupInfoListTile(
            title: 'Group Name',
            subtitle: 'Group ID',
            image:
                'https://www.nubedigital.mx/flexo/assets/imagenesblog/imagenesblog/f-google-classroom-para-empresas.jpg',
            onTap: () {
              Navigator.pushNamed(context, 'group_info');
            },
          );
        },
      ),
    );
  }
}
