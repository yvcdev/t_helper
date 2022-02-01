import 'package:flutter/material.dart';

import 'package:t_helper/layouts/layouts.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarLayout(
      drawer: false,
      title: 'Notifications',
      children: [Container()],
    );
  }
}
