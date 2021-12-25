import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/options_lists/options_lists.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';
import 'package:t_helper/helpers/helpers.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;
    final _cards = groupInfoList(context);

    return NotificationsAppBarLayout(
      elevation: 0,
      title: 'Group infomation',
      topSeparation: false,
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
      child: Expanded(
        child: Column(
          children: [
            _HeroInfo(group: group),
            GridSingleCardTwo(
              cards: _cards,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroInfo extends StatelessWidget {
  const _HeroInfo({
    Key? key,
    required this.group,
  }) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return HeroInfo(
      imageUrl: group.image,
      children: [
        Text(
          group.subject.toTitleCase(),
          style: const TextStyle(
            fontSize: UiConsts.largeFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          group.level.toCapitalized(),
          style: const TextStyle(
              fontSize: UiConsts.smallFontSize - 2, color: CustomColors.green),
        ),
        const SizedBox(
          height: UiConsts.smallSpacing,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members: ${group.members.length}',
              style: const TextStyle(
                fontSize: UiConsts.smallFontSize,
              ),
            ),
            Text(
              'Activities: ${group.members.length}',
              style: const TextStyle(
                fontSize: UiConsts.smallFontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
