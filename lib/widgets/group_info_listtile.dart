import 'package:flutter/material.dart';

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
          margin: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            customBorder:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onTap: () {
              onTap();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(children: [
                _Trailing(trailing: trailing),
                const SizedBox(
                  width: 10,
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
        return CircleAvatar(
          foregroundImage: NetworkImage(trailing!),
          radius: 25,
        );
      } else if (trailing is IconData) {
        return Icon(
          trailing,
          size: 40,
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
