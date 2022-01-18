import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

class ImageDescriptionCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int status; // 0 not started - 1 started - 2 completed - 3 failed
  final Function onTap;
  final int index;

  const ImageDescriptionCard(
      {Key? key,
      required this.title,
      required this.image,
      required this.description,
      required this.status,
      required this.index,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: UiConsts.largeCardHeight + 35,
        width: 150,
        decoration: BoxDecoration(
          color: UiConsts.colors[index % UiConsts.colors.length],
          borderRadius: BorderRadius.circular(UiConsts.borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Image(image: image),
            _Title(title: title),
            _Description(description: description),
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: UiConsts.tinySpacing),
        child: Text(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: UiConsts.tinyFontSize - 1, color: Colors.white),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: UiConsts.tinySpacing, vertical: UiConsts.tinySpacing + 5),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white,
            fontSize: UiConsts.smallFontSize,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(UiConsts.borderRadius),
            topRight: Radius.circular(UiConsts.borderRadius)),
        child: FadeInImage(
          placeholder: const AssetImage('assets/no_image.jpg'),
          image: NetworkImage(image),
          fit: BoxFit.cover,
          height: 110,
          width: 150,
        ));
  }
}
