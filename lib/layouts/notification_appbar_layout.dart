import 'package:flutter/material.dart';

import 'package:t_helper/widgets/widgets.dart';

class NotificationsAppBarLayout extends StatelessWidget {
  final Widget child;
  final String? title;

  const NotificationsAppBarLayout({Key? key, required this.child, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? routeName = ModalRoute.of(context)!.settings.name;

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: routeName == 'notifications'
                ? null
                : () {
                    Navigator.pushNamed(context, 'notifications');
                  },
            iconSize: 30,
            splashRadius: 20,
          )
        ],
        title: Text(
          title ?? '',
        ),
      ),
      body: GradientBackground(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
