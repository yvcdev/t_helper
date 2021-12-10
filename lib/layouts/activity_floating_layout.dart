import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/routes/routes.dart';

import 'package:t_helper/widgets/widgets.dart';

class ActivityFloatingLayoutLayout extends StatelessWidget {
  final Widget child;
  final IconData? floatingIcon;
  final Function? floatingAction;
  final String title;

  const ActivityFloatingLayoutLayout(
      {Key? key,
      required this.child,
      this.floatingIcon,
      this.floatingAction,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (floatingAction == null) {
                Navigator.pushNamed(context, Routes.TEACHER_HOME);
              } else {
                floatingAction!();
              }
            },
            icon: Icon(
              floatingIcon ?? Icons.home,
              size: UiConsts.largeFontSize,
            ),
          ),
        ],
      ),
      body: GradientBackground(
        child: child,
      ),
    );
  }
}
