import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:t_helper/utils/utils.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool? safeArea;

  const GradientBackground(
      {Key? key, required this.child, this.safeArea = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.decal,
              stops: [0.2, 0.9],
              colors: [
                CustomColors.primary,
                CustomColors.secondary,
              ],
            ),
          ),
        ),
        safeArea != null
            ? SafeArea(
                child: child,
              )
            : child,
      ],
    );
  }
}
