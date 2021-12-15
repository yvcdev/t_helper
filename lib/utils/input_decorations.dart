import 'package:flutter/material.dart';
import 'package:t_helper/utils/custom_colors.dart';

class InputDecorations {
  static InputDecoration generalInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: CustomColors.primary),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: CustomColors.primary, width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: CustomColors.primary,
            )
          : null,
    );
  }
}
