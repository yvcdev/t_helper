import 'package:flutter/material.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/options_lists/options_lists.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _cards = teacherHomeInfoList(context);

    return NotificationsAppBarLayout(
      title: 'Home',
      appBarBottomHeight: 80,
      appBarBottom: const _AppBarBottom(),
      child: GridSingleCardTwo(
        cards: _cards,
      ),
    );
  }
}

class _AppBarBottom extends StatelessWidget {
  const _AppBarBottom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Hello',
          style: TextStyle(
              color: Colors.white, fontSize: UiConsts.normalFontSize - 4),
        ),
        Text(
          'Yeison Valencia',
          style: TextStyle(
              color: Colors.white,
              fontSize: UiConsts.normalFontSize,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final List<Map<String, dynamic>> children;

  const _Row({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SingleCard(
          color: children[0]['color'],
          icon: children[0]['icon'],
          text: children[0]['text'],
          onTap: children[0]['onTap'],
        ),
        SingleCard(
          color: children[1]['color'],
          icon: children[1]['icon'],
          text: children[1]['text'],
          onTap: children[1]['onTap'],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String text;
  final Function onTap;

  const _SingleCard({
    Key? key,
    this.color,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiConsts.borderRadius)),
      onTap: () => onTap(),
      child: Container(
        height: UiConsts.normalCardHeight,
        width: UiConsts.smallCardHeight + 30,
        padding: const EdgeInsets.all(UiConsts.normalPadding),
        decoration: BoxDecoration(
          color: color ?? CustomColors.secondaryDark,
          borderRadius: BorderRadius.circular(UiConsts.borderRadius),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: UiConsts.extraLargeFontSize,
            ),
            const SizedBox(
              height: UiConsts.smallSpacing,
            ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: UiConsts.normalFontSize - 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
