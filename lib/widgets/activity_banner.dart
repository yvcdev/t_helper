import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/custom_colors.dart';

class ActivityBanner extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int status; // 0 not started - 1 started - 2 completed - 3 failed
  final Function onTap;

  const ActivityBanner(
      {Key? key,
      required this.title,
      required this.image,
      required this.description,
      required this.status,
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
        height: UiConsts.largeCardHeight,
        width: 150,
        decoration: BoxDecoration(
          color: CustomColors.secondaryDark,
          borderRadius: BorderRadius.circular(UiConsts.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _Image(image: image),
                _Completion(status: status),
              ],
            ),
            _Title(title: title),
            _Description(description: description),
            const SizedBox(
              height: UiConsts.tinySpacing,
            ),
            const _Date(),
            const SizedBox(
              height: UiConsts.tinySpacing,
            ),
          ],
        ),
      ),
    );
  }
}

class _Completion extends StatelessWidget {
  final int status;

  const _Completion({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.orange;
    String label = 'Not started';
    if (status == 1) {
      color = Colors.blue;
      label = 'Started';
    } else if (status == 2) {
      color = Colors.green;
      label = 'Completed';
    } else if (status == 3) {
      color = Colors.red;
      label = 'Failed';
    }

    return Positioned(
        child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(UiConsts.borderRadius),
          bottomRight: Radius.circular(UiConsts.borderRadius),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: UiConsts.tinyFontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
    ));
  }
}

class _Date extends StatelessWidget {
  const _Date({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.access_time_filled_rounded,
          size: UiConsts.smallFontSize,
        ),
        const SizedBox(
          width: UiConsts.tinySpacing,
        ),
        Text(
          'September 19',
          style:
              TextStyle(color: Colors.black.withOpacity(UiConsts.muchOpacity)),
        )
      ],
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
          style: const TextStyle(
              fontSize: UiConsts.tinyFontSize, color: CustomColors.almostBlack),
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
      padding: const EdgeInsets.all(UiConsts.tinySpacing),
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
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
