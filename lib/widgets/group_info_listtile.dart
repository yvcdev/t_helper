import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

class GroupInfoListTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final bool? useAssetImage;
  final int index;

  const GroupInfoListTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.index,
    this.subtitle,
    this.trailing,
    this.useAssetImage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: UiConsts.smallPadding - 2,
              vertical: UiConsts.normalPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiConsts.borderRadius - 5),
              gradient: LinearGradient(colors: [
                UiConsts.colors[index % UiConsts.colors.length],
                UiConsts.colors[index % UiConsts.colors.length].withOpacity(0.9)
              ])),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiConsts.borderRadius - 5)),
            onTap: () {
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: UiConsts.smallPadding),
              child: Row(children: [
                const SizedBox(
                  width: UiConsts.smallSpacing,
                ),
                Expanded(
                  child: _Center(
                    title: title,
                    subtitle: subtitle,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                _Trailing(trailing: trailing, useAssetImage: useAssetImage),
              ]),
            ),
          )),
    );
  }
}

class _Trailing extends StatelessWidget {
  final dynamic trailing;
  final bool? useAssetImage;

  const _Trailing({Key? key, this.trailing, this.useAssetImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trailing != null || useAssetImage == true) {
      if (trailing is String && trailing.toString().startsWith('http') ||
          useAssetImage == true) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(UiConsts.smallPadding),
            topRight: Radius.circular(UiConsts.smallPadding),
          ),
          child: Container(
              child: useAssetImage!
                  ? Image.asset('assets/no_image.jpg')
                  : FadeInImage(
                      image: NetworkImage(trailing!),
                      placeholder: const AssetImage('assets/no_image.jpg'),
                      fit: BoxFit.cover,
                    ),
              height: UiConsts.largeImageRadius * 2,
              width: UiConsts.largeImageRadius * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UiConsts.largeImageRadius),
              )),
        );
      } else if (trailing is IconData) {
        return Icon(
          trailing,
          color: Colors.white,
          size: UiConsts.extraLargeFontSize,
        );
      }
    } else {
      return const SizedBox();
    }

    return const SizedBox();
  }
}

class _Center extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _Center({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: UiConsts.normalFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: subtitle == null ? 0 : 2,
        ),
        subtitle == null
            ? const SizedBox()
            : Text(subtitle!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: UiConsts.smallFontSize,
                )),
      ],
    );
  }
}
