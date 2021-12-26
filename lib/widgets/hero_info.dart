import 'package:flutter/material.dart';

import 'package:t_helper/constants/constants.dart';

class HeroInfo extends StatelessWidget {
  final String? imageUrl;
  final List<Widget> children;

  const HeroInfo({Key? key, this.imageUrl, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [UiConsts.boxShadow],
      ),
      child: Column(
        children: [
          _Image(imageUrl: imageUrl),
          Container(
            padding: const EdgeInsets.all(UiConsts.normalPadding),
            child: Column(
              children: children,
            ),
          )
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: imageUrl == null
          ? Container()
          : FadeInImage(
              image: NetworkImage(imageUrl!),
              placeholder: const AssetImage('assets/no_image.jpg'),
              fit: BoxFit.cover,
              height: 200,
            ),
    );
  }
}
