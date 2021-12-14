import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class ActivityFloatingLayoutLayout extends StatelessWidget {
  final Widget child;
  final IconData? floatingIcon;
  final Function? floatingAction;
  final String title;
  final bool? loading;

  const ActivityFloatingLayoutLayout({
    Key? key,
    required this.child,
    this.floatingIcon,
    this.floatingAction,
    required this.title,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading!) {
      return const LoadingScreen();
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              CustomColors.primary,
              CustomColors.primaryGradient,
            ])),
          ),
          title: Text(title),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                if (floatingAction == null) {
                  customPopup(
                    context: context,
                    correctText: 'Do you want to go home?',
                    label: 'Yes',
                    cancelLabel: 'No',
                    correct: true,
                    onAccept: () => Navigator.pushReplacementNamed(
                        context, Routes.TEACHER_HOME),
                    onCancel: () => Navigator.of(context).pop(),
                  );
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
        body: Background(
          child: child,
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await customPopup(
          context: context,
          correctText: 'Do you want to exit?',
          label: 'Yes',
          cancelLabel: 'No',
          correct: true,
          onAccept: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        ) ??
        false;
  }
}
