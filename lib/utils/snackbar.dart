import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

SnackBar snackbar({required String message, bool success = true}) {
  final snackBar = SnackBar(
    backgroundColor: success ? Colors.green : Colors.red,
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.white, fontSize: UiConsts.smallFontSize),
    ),
  );

  return snackBar;
}
