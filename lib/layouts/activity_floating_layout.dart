import 'package:flutter/material.dart';

import 'package:t_helper/utils/custom_colors.dart';
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: FloatingActionButton(
          onPressed: () {
            if (floatingAction == null) {
              Navigator.pushNamed(context, 'home');
            } else {
              floatingAction!();
            }
          },
          backgroundColor: CustomColors.primary,
          child: Icon(floatingIcon ?? Icons.home),
        ),
      ),
      body: GradientBackground(
        child: child,
      ),
    );
  }
}
