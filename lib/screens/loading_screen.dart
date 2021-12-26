import 'package:flutter/material.dart';
import 'dart:async';

const _duration = 900;

class LoadingScreen extends StatefulWidget {
  final bool? useScafold;

  const LoadingScreen({Key? key, this.useScafold = true}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double _width = 60;
  double _margin = 0;
  double _height = 50;

  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: _duration),
      (Timer t) => _cambiarForma(),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (widget.useScafold!) {
      return Scaffold(
        body: _LoadingBody(width: _width, height: _height, margin: _margin),
      );
    }

    return Container(
        height: screenHeight - 130,
        child: _LoadingBody(width: _width, height: _height, margin: _margin));
  }

  void _cambiarForma() {
    setState(() {
      if (_width == 60.0) {
        _width = 0.0;
        _height = 0.0;
        _margin = 60.0;
      } else if (_width == 0.0) {
        _width = 60.0;
        _height = 50.0;
        _margin = 0.0;
      }
    });
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({
    Key? key,
    required double width,
    required double height,
    required double margin,
  })  : _width = width,
        _height = height,
        _margin = margin,
        super(key: key);

  final double _width;
  final double _height;
  final double _margin;

  @override
  Widget build(BuildContext context) {
    return (Center(
      child: Container(
        alignment: Alignment.center,
        height: 150,
        width: 150,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const SizedBox(
              height: 150,
              width: 150,
              child: CircularProgressIndicator(
                color: Color.fromRGBO(188, 172, 22, 1),
                strokeWidth: 3,
              ),
            ),
            _AnimatedContainer(
              width: _width,
              height: _height,
              margin: _margin,
            ),
          ],
        ),
      ),
    ));
  }
}

class _AnimatedContainer extends StatelessWidget {
  final double width;
  final double height;
  final double margin;

  const _AnimatedContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      width: 120,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Left(
                width: width,
              ),
              _Right(
                margin: margin,
                width: width,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Bottom(
                height: height,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Left extends StatelessWidget {
  final double width;

  const _Left({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: _duration),
      curve: Curves.easeInSine,
      width: width,
      height: 40,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo/left.png'),
        ),
      ),
    );
  }
}

class _Right extends StatelessWidget {
  final double width;
  final double margin;

  const _Right({
    Key? key,
    required this.width,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(left: margin),
      duration: const Duration(milliseconds: _duration),
      curve: Curves.easeInSine,
      width: width,
      height: 40,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo/right.png'),
        ),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final double height;

  const _Bottom({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: _duration),
      curve: Curves.easeInSine,
      width: 40,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/logo/bottom.png'),
        ),
      ),
    );
  }
}
