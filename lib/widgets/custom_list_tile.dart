import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/custom_colors.dart';

class CustomListTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final bool? useAssetImage;
  final int index;
  final String? assetImageName;
  final Function onDismissed;
  final bool? dismissible;
  final bool? centerText;
  final bool? addPadding;
  final Icon? dismissIcon;
  final Color? dismissBackgroundColor;
  final Function? onLongPress;

  const CustomListTile({
    Key? key,
    required this.onTap,
    required this.title,
    required this.index,
    required this.onDismissed,
    this.centerText = false,
    this.dismissible = true,
    this.subtitle,
    this.trailing,
    this.useAssetImage = false,
    this.assetImageName = 'no_image.jpg',
    this.addPadding = false,
    this.dismissIcon,
    this.dismissBackgroundColor,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (dismissible! == false) {
      return _Content(
        index: index,
        onTap: onTap,
        onLongPress: onLongPress,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        useAssetImage: useAssetImage,
        assetImageName: assetImageName,
        centerText: centerText!,
        addPadding: addPadding!,
      );
    }

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: UiConsts.smallPadding,
              vertical: UiConsts.smallPadding),
          padding: const EdgeInsets.all(UiConsts.normalPadding),
          alignment: Alignment.centerRight,
          child: dismissIcon ??
              const Icon(
                Icons.delete,
                color: Colors.white,
              ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiConsts.borderRadius - 5),
              color: dismissBackgroundColor ?? CustomColors.red)),
      key: UniqueKey(),
      onDismissed: (direction) {
        onDismissed();
      },
      child: _Content(
        index: index,
        onTap: onTap,
        onLongPress: onLongPress,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        useAssetImage: useAssetImage,
        assetImageName: assetImageName,
        centerText: centerText!,
        addPadding: addPadding!,
      ),
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
    required this.centerText,
    required this.addPadding,
    this.onLongPress,
  }) : super(key: key);

  final int index;
  final Function onTap;
  final Function? onLongPress;
  final String title;
  final String? subtitle;
  final dynamic trailing;
  final bool? useAssetImage;
  final String? assetImageName;
  final bool centerText;
  final bool addPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: UiConsts.smallPadding, vertical: UiConsts.smallPadding),
        padding: addPadding
            ? const EdgeInsets.all(UiConsts.normalPadding)
            : EdgeInsets.zero,
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
          onLongPress: onLongPress == null
              ? null
              : () {
                  onLongPress!();
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
                  centerText: centerText,
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
  final bool centerText;

  const _Center({
    Key? key,
    required this.title,
    this.subtitle,
    required this.centerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          centerText ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: centerText ? TextAlign.center : TextAlign.right,
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
                textAlign: centerText ? TextAlign.center : TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: UiConsts.smallFontSize,
                )),
      ],
    );
  }
}
