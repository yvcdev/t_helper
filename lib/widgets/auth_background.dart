import 'package:flutter/material.dart';
import 'package:t_helper/utils/custom_colors.dart';

class AuthBg extends StatelessWidget {
  final Widget child;

  const AuthBg({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [const _TopContainer(), const _HeaderIcon(), child],
      ),
    );
  }
}

class _TopContainer extends StatelessWidget {
  const _TopContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _coloredBackground(),
      child: Stack(
        children: const [
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, right: -30),
          Positioned(child: _Bubble(), top: -50, left: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 120, right: 20),
        ],
      ),
    );
  }

  BoxDecoration _coloredBackground() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        CustomColors.primary,
        CustomColors.primaryGradient,
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 45, left: 45, right: 45),
        child: const Image(image: AssetImage('assets/logo/logo.png')),
      ),
    );
  }
}
