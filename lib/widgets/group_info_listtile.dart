import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

class GroupInfoListTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? subtitle;
  final dynamic trailing;

  const GroupInfoListTile(
      {Key? key,
      required this.onTap,
      required this.title,
      this.subtitle,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.only(
              left: UiConsts.smallSpacing,
              right: UiConsts.smallSpacing,
              top: UiConsts.smallPadding,
              bottom: UiConsts.smallPadding),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(UiConsts.borderRadius),
          ),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: () {
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.all(UiConsts.smallPadding),
              child: Row(children: [
                _Trailing(trailing: trailing),
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
                const Icon(Icons.arrow_forward_ios_rounded),
              ]),
            ),
          )),
    );
  }
}

class _Trailing extends StatelessWidget {
  final dynamic trailing;

  const _Trailing({Key? key, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trailing != null) {
      if (trailing is String && trailing.toString().startsWith('http')) {
        return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: FadeInImage(
              image: NetworkImage(trailing!),
              placeholder: const AssetImage('assets/no_image.jpg'),
              fit: BoxFit.cover,
            ),
            height: UiConsts.normalImageRadius * 2,
            width: UiConsts.normalImageRadius * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(UiConsts.normalImageRadius),
            ));
      } else if (trailing is IconData) {
        return Icon(
          trailing,
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
          style: textStyle.subtitle1,
        ),
        SizedBox(
          height: subtitle == null ? 0 : 6,
        ),
        subtitle == null
            ? const SizedBox()
            : Text(
                subtitle!,
                style: textStyle.subtitle2,
              ),
      ],
    );
  }
}
