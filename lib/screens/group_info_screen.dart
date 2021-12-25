import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/options_lists/options_lists.dart';
import 'package:t_helper/widgets/widgets.dart';
import 'package:t_helper/helpers/helpers.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;
    final _cards = groupInfoList(context);

    return NotificationsAppBarLayout(
      title: 'Group infomation',
      appBarBottomHeight: 50,
      appBarBottom: Column(
        children: [
          Text(group.name.toTitleCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: UiConsts.largeFontSize,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      child: GridSingleCardTwo(
        cards: _cards,
      ),
    );
  }
}
