import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/utils/utils.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
        title: 'Home',
        child: Column(children: [
          const SizedBox(
            height: UiConsts.normalSpacing,
          ),
          _Row(children: [
            {
              'color': Colors.blue,
              'icon': Icons.create,
              'text': 'Create activity',
              'onTap': () {
                Navigator.pushNamed(context, Routes.CREATE_ACTIVITY);
              },
            },
            {
              'color': Colors.orange,
              'icon': Icons.group_add,
              'text': 'Create group',
              'onTap': () {
                Navigator.pushNamed(context, Routes.CREATE_GROUP);
              },
            }
          ])
        ]));
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
        _SingleCard(
          color: children[0]['color'],
          icon: children[0]['icon'],
          text: children[0]['text'],
          onTap: children[0]['onTap'],
        ),
        _SingleCard(
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
  final Color color;
  final IconData icon;
  final String text;
  final Function onTap;

  const _SingleCard({
    Key? key,
    required this.color,
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
        height: UiConsts.smallCardHeight,
        width: UiConsts.smallCardHeight,
        padding: const EdgeInsets.all(UiConsts.smallPadding),
        decoration: BoxDecoration(
            color: CustomColors.almostWhite,
            borderRadius: BorderRadius.circular(UiConsts.borderRadius),
            boxShadow: [UiConsts.boxShadow]),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
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
                      color: CustomColors.almostBlack,
                      fontSize: UiConsts.smallFontSize,
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
