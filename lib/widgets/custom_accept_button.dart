import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/custom_colors.dart';

class CustomAcceptButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final IconData? iconData;
  final Color? color;

  const CustomAcceptButton(
      {Key? key,
      required this.onTap,
      required this.title,
      this.iconData,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(UiConsts.borderRadius),
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: UiConsts.extraLargePadding,
            vertical: UiConsts.normalPadding),
        child: Text(title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: UiConsts.largeFontSize,
            )),
        decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: color ?? CustomColors.green,
            shadows: [UiConsts.boxShadow]),
      ),
    );
  }
}
