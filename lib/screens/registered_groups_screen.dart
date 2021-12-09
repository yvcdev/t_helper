import 'package:flutter/material.dart';
import 'package:t_helper/widgets/group_list_view.dart';

import 'package:t_helper/widgets/widgets.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
            iconSize: 30,
            splashRadius: 20,
          )
        ],
        title: const Image(
            height: 80,
            image: AssetImage('assets/logo-space.png'),
            fit: BoxFit.contain),
      ),
      body: const GradientBackground(child: GroupListView()),
    );
  }
}
