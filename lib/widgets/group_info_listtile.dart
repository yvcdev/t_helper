import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/custom_colors.dart';

class GroupInfoListTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final bool? useAssetImage;
  final int index;
  final String? assetImageName;
  final Function onDeleteDismiss;
  final bool? dismissible;

  const GroupInfoListTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.index,
    required this.onDeleteDismiss,
    this.dismissible = true,
    this.subtitle,
    this.trailing,
    this.useAssetImage = false,
    this.assetImageName = 'no_image.jpg',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dismissible! == false) {
      return _Content(
          index: index,
          onTap: onTap,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          useAssetImage: useAssetImage,
          assetImageName: assetImageName);
    }

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: UiConsts.smallPadding - 2,
              vertical: UiConsts.normalPadding),
          padding: const EdgeInsets.all(UiConsts.normalPadding),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiConsts.borderRadius - 5),
              color: CustomColors.red)),
      key: UniqueKey(),
      onDismissed: (direction) {
        onDeleteDismiss();
      },
      child: _Content(
          index: index,
          onTap: onTap,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          useAssetImage: useAssetImage,
          assetImageName: assetImageName),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.index,
    required this.onTap,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.useAssetImage,
    required this.assetImageName,
  }) : super(key: key);

  final int index;
  final Function onTap;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final bool? useAssetImage;
  final String? assetImageName;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              _Trailing(
                trailing: trailing,
                useAssetImage: useAssetImage,
                assetImageName: assetImageName!,
              ),
            ]),
          ),
        ));
  }
}

class _Trailing extends StatelessWidget {
  final dynamic trailing;
  final bool? useAssetImage;
  final String assetImageName;

  const _Trailing(
      {Key? key,
      this.trailing,
      this.useAssetImage = false,
      required this.assetImageName})
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
                  ? Image.asset('assets/$assetImageName')
                  : FadeInImage(
                      image: NetworkImage(trailing!),
                      placeholder: AssetImage('assets/$assetImageName'),
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
