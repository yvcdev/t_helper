import 'package:flutter/material.dart';

class GroupInfoListTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String? subtitle;
  final String? image;

  const GroupInfoListTile(
      {Key? key,
      required this.onTap,
      required this.title,
      this.subtitle,
      this.image})
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
                image == null
                    ? const SizedBox()
                    : CircleAvatar(
                        foregroundImage: NetworkImage(image!),
                        radius: 25,
                      ),
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
