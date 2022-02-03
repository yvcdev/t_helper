import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/custom_colors.dart';

class CustomTextButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  const CustomTextButton(
      {Key? key, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(
            CustomColors.primary.withOpacity(0.1),
          ),
          shape: MaterialStateProperty.all(const StadiumBorder())),
      onPressed: () {
        onPressed();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: CustomColors.primary, fontSize: UiConsts.smallFontSize),
      ),
    );
  }
}
