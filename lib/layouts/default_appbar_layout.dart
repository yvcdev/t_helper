import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/custom_colors.dart';
import 'package:t_helper/widgets/widgets.dart';

class DefaultAppBarLayout extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final bool? topSeparation;
  final bool? loading;
  final Widget? appBarBottom;
  final double? appBarBottomHeight;
  final double? elevation;
  final bool? scroll;
  final bool? colunmLayout;
  final bool? drawer;
  final bool? showActionButton;
  final bool? showAdditionalOptions;
  final List<String>? additionalOptions;
  final Map<String, Function>? optionFunctions;

  DefaultAppBarLayout(
      {Key? key,
      required this.children,
      this.title,
      this.topSeparation = true,
      this.loading = false,
      this.appBarBottom,
      this.appBarBottomHeight,
      this.elevation,
      this.scroll = true,
      this.colunmLayout = false,
      this.drawer = true,
      this.showActionButton = true,
      this.showAdditionalOptions = false,
      this.additionalOptions,
      this.optionFunctions})
      : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final String? routeName = ModalRoute.of(context)!.settings.name;

    if (loading!) {
      return const LoadingScreen();
    }

    void handleAdditionalOption(String value) {
      if (optionFunctions != null && optionFunctions!.containsKey(value)) {
        optionFunctions![value]!();
      }
    }

    return Scaffold(
      drawer: drawer!
          ? CustomDrawer(
              scaffoldKey: _scaffoldKey,
            )
          : null,
      key: _scaffoldKey,
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
          showActionButton!
              ? IconButton(
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                  onPressed: routeName == '/NotificationsScreen'
                      ? null
                      : () {
                          Get.to(() => const NotificationsScreen());
                        },
                  iconSize: 30,
                  splashRadius: 20,
                )
              : Container(),
          showAdditionalOptions!
              ? PopupMenuButton<String>(
                  onSelected: handleAdditionalOption,
                  itemBuilder: (BuildContext context) {
                    if (additionalOptions != null &&
                        additionalOptions!.isNotEmpty) {
                      return additionalOptions!.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice[0].toUpperCase() +
                              choice.substring(1).toLowerCase()),
                        );
                      }).toList();
                    } else if (additionalOptions != null &&
                        additionalOptions!.isEmpty) {
                      return {'No options'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    } else {
                      return {'No options'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    }
                  },
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
        child: colunmLayout!
            ? Column(
                children: [
                  SizedBox(height: topSeparation! ? 10 : 0),
                  ...children,
                ],
              )
            : ListView(
                physics: scroll!
                    ? const ScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(height: topSeparation! ? 10 : 0),
                  ...children,
                ],
              ),
      ),
    );
  }
}
