import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/utils/utils.dart';

class Snackbar {
  static const _duration = Duration(seconds: 1);

  static void error(
    String title,
    String message,
  ) {
    Get.snackbar(
      title.toTitleCase(),
      message.toCapitalized(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: CustomColors.red,
      duration: _duration,
      titleText: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: UiConsts.normalFontSize),
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: UiConsts.smallFontSize),
      ),
    );
  }

  static void success(
    String title,
    String message,
  ) {
    Get.snackbar(
      title.toTitleCase(),
      message.toCapitalized(),
      snackPosition: SnackPosition.BOTTOM,
      duration: _duration,
      backgroundColor: CustomColors.green,
      titleText: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: UiConsts.normalFontSize),
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: UiConsts.smallFontSize),
      ),
    );
  }

  static void info(
    String title,
    String message,
  ) {
    Get.snackbar(
      title.toTitleCase(),
      message.toCapitalized(),
      snackPosition: SnackPosition.BOTTOM,
      duration: _duration,
      backgroundColor: CustomColors.primary,
      titleText: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: UiConsts.normalFontSize),
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: UiConsts.smallFontSize),
      ),
    );
  }
}
