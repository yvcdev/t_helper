import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/utils.dart';

class SingleCard extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final String text;
  final Function onTap;
  final int index;

  const SingleCard({
    Key? key,
    this.color,
    required this.icon,
    required this.text,
    required this.onTap,
    required this.index,
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
          color: UiConsts.colors[index % UiConsts.colors.length],
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
                      fontSize: UiConsts.normalFontSize - 4,
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
