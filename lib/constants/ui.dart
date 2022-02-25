import 'package:flutter/material.dart';

class UiConsts {
  static const borderRadius = 15.0;
  static const tinySpacing = 7.0;
  static const smallSpacing = 10.0;
  static const normalSpacing = 20.0;
  static const largeSpacing = 30.0;
  static const extraLargeSpacing = 90.0;
  static const hugeSpacing = 150.0;
  static const smallCardHeight = 120.0;
  static const normalCardHeight = 150.0;
  static const largeCardHeight = 250.0;
  static const tinyFontSize = 13.5;
  static const smallFontSize = 15.0;
  static const normalFontSize = 20.0;
  static const largeFontSize = 28.0;
  static const extraLargeFontSize = 42.0;
  static const smallPadding = 8.0;
  static const normalPadding = 14.0;
  static const largePadding = 20.0;
  static const extraLargePadding = 35.0;
  static const normalImageRadius = 25.0;
  static const largeImageRadius = 45.0;

  static const littleOpacity = 0.2;
  static const normalOpacity = 0.5;
  static const muchOpacity = 0.8;

  static final boxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.3),
    offset: const Offset(-1, 1),
    blurRadius: 5,
  );

  static const colors = [
    Colors.teal,
    Color.fromRGBO(241, 196, 15, 1),
    Color.fromRGBO(155, 89, 182, 1),
    Color.fromRGBO(69, 81, 249, 1),
    Color.fromRGBO(248, 182, 25, 1),
    Colors.deepPurpleAccent,
    Color.fromRGBO(41, 128, 185, 1),
    Color.fromRGBO(46, 204, 113, 1),
  ];
}
