import 'package:flutter/material.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/custom_colors.dart';

import 'package:t_helper/widgets/widgets.dart';

class ActionAppBarLayout extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final bool? topSeparation;
  final bool? loading;
  final Widget? appBarBottom;
  final double? appBarBottomHeight;
  final double? elevation;
  final Icon? actionIcon;
  final Function? onActionPressed;

  ActionAppBarLayout({
    Key? key,
    required this.children,
    this.title,
    this.topSeparation = true,
    this.loading = false,
    this.appBarBottom,
    this.appBarBottomHeight,
    this.elevation,
    this.onActionPressed,
    this.actionIcon,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    if (loading!) {
      return const LoadingScreen();
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        scaffoldKey: _scaffoldKey,
      ),
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
          actionIcon != null
              ? IconButton(
                  icon: actionIcon!,
                  onPressed: () {
                    if (onActionPressed != null && actionIcon != null) {
                      onActionPressed!();
                    }
                  },
                  iconSize: 30,
                  splashRadius: 20,
                )
              : Container(),
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
