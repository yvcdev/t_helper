import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  final Function onTap;

  const GroupListTile({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
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
              child: Row(children: const [
                CircleAvatar(
                  radius: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _Center(),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.arrow_forward_ios_rounded),
              ]),
            ),
          )),
    );
  }
}

class _Center extends StatelessWidget {
  const _Center({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Group name',
          style: textStyle.subtitle1,
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          'Group ID',
          style: textStyle.subtitle2,
        ),
      ],
    );
  }
}
