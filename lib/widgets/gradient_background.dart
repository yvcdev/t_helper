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
        const _Bubble(size: 50, bottom: 100, left: 65),
        const _Bubble(size: 80, right: 100, top: 100),
        const _Bubble(size: 100, left: 86, top: 250),
        const _Bubble(size: 120, top: 10, left: 25),
        const _Bubble(size: 90, bottom: 50, right: 20),
        const _Bubble(size: 150, bottom: 290, right: -40),
        const _Bubble(size: 100, bottom: -33, left: -25),
        safeArea != null
            ? SafeArea(
                child: child,
              )
            : child,
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final double size;
  final double? bottom;
  final double? top;
  final double? right;
  final double? left;
  const _Bubble(
      {Key? key,
      required this.size,
      this.bottom,
      this.top,
      this.right,
      this.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      top: top,
      left: left,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
    );
  }
}
