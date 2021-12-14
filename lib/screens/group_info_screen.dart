import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/options_lists/options_lists.dart';
import 'package:t_helper/widgets/widgets.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cards = groupInfoList(context);

    return NotificationsAppBarLayout(
      title: 'Group infomation',
      appBarBottomHeight: 50,
      appBarBottom: Column(
        children: const [
          Text('NaPower',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: UiConsts.largeFontSize,
                  fontWeight: FontWeight.bold)),
          SizedBox(
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
