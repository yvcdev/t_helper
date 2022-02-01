import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/user_controller.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/options_lists/options_lists.dart';
import 'package:t_helper/widgets/widgets.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cards = teacherHomeInfoList(context);

    return DefaultAppBarLayout(
        title: 'Home',
        appBarBottomHeight: 80,
        appBarBottom: const _AppBarBottom(),
        children: [
          GridSingleCardTwo(cards: _cards),
        ]);
  }
}

class _AppBarBottom extends StatelessWidget {
  const _AppBarBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = UserController.instance.user;

    return Column(
      children: [
        const Text(
          'Hello',
          style: TextStyle(
              color: Colors.white, fontSize: UiConsts.normalFontSize - 4),
        ),
        Obx(() => Text(
              user.value.preferredName == 'firstName'
                  ? '${user.value.firstName!} ${user.value.lastName!}'
                  : '${user.value.middleName!} ${user.value.lastName!}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: UiConsts.normalFontSize,
                  fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
