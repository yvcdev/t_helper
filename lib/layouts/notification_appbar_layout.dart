import 'package:flutter/material.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/custom_colors.dart';

import 'package:t_helper/widgets/widgets.dart';

class NotificationsAppBarLayout extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final bool? topSeparation;
  final bool? loading;
  final Widget? appBarBottom;
  final double? appBarBottomHeight;
  final double? elevation;

  const NotificationsAppBarLayout({
    Key? key,
    required this.children,
    this.title,
    this.topSeparation = true,
    this.loading = false,
    this.appBarBottom,
    this.appBarBottomHeight,
    this.elevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? routeName = ModalRoute.of(context)!.settings.name;

    if (loading!) {
      return const LoadingScreen();
    }

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        elevation: elevation,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            CustomColors.primary,
            CustomColors.primaryGradient,
          ])),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: routeName == Routes.NOTIFICATIONS
                ? null
                : () {
                    Navigator.pushNamed(context, Routes.NOTIFICATIONS);
                  },
            iconSize: 30,
            splashRadius: 20,
          )
        ],
        title: Text(
          title ?? '',
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(appBarBottomHeight ?? 0),
          child: appBarBottom == null ? Container() : appBarBottom!,
        ),
      ),
      body: Background(
        child: ListView(
          children: [
            SizedBox(height: topSeparation! ? 10 : 0),
            ...children,
          ],
        ),
      ),
    );
  }
}
