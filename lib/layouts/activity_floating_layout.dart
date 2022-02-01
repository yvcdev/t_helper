import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/home_wrapper.dart';
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

    return Scaffold(
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
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => MinimalPopUp(
                          topImage: false,
                          correctText: 'Do you want to go to the home screen?',
                          acceptButtonLabel: 'Yes',
                          cancelButtonLabel: 'No',
                          acceptButtonColor: CustomColors.red,
                          cancelButtonColor: CustomColors.green,
                          onAccept: () => Get.offAll(() => const HomeWrapper()),
                          onCancel: () => Get.back(),
                        ));
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
    );
  }
}
