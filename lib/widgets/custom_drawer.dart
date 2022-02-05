import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/home_wrapper.dart';

class CustomDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomDrawer({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    return Drawer(
      child: Column(
        children: [
          const _Header(),
          _Body(scaffoldKey: scaffoldKey),
          _ListTile(
              scaffoldKey: scaffoldKey,
              iconData: Icons.logout,
              onTap: () async {
                await authController.signOut();
              },
              title: 'Sign Out'),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _Body({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String route = Get.currentRoute;

    return Expanded(
      child: Container(
        color: CustomColors.almostWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _ListTile(
                scaffoldKey: scaffoldKey,
                iconData: Icons.home,
                onTap: () {
                  if (route == '/HomeWrapper') {
                    Get.back();
                  } else {
                    Get.offAll(() => const HomeWrapper());
                  }
                },
                title: 'Home'),
            _ListTile(
                scaffoldKey: scaffoldKey,
                iconData: Icons.group,
                onTap: () {
                  if (route == '/RegisteredGroupScreen') {
                    Get.back();
                  } else {
                    Get.offAll(() => const RegisteredGroupScreen());
                  }
                },
                title: 'Groups'),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function onTap;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _ListTile({
    Key? key,
    required this.iconData,
    required this.title,
    required this.scaffoldKey,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Icon(
        iconData,
        color: CustomColors.primaryGradient,
        size: UiConsts.largeFontSize,
      ),
      onTap: () {
        onTap();
      },
      title: Text(
        title,
        textAlign: TextAlign.end,
        style: const TextStyle(
          color: CustomColors.almostBlack,
          fontSize: UiConsts.normalFontSize - 4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    final user = userController.user;

    return DrawerHeader(
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Image(
              width: 100,
              image: AssetImage('assets/logo/logo.png'),
              fit: BoxFit.contain,
            ),
            const Expanded(child: SizedBox()),
            Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: user.value.profilePic == null
                    ? Image.asset('assets/no_profile.png')
                    : FadeInImage(
                        image: NetworkImage(user.value.profilePic!),
                        placeholder: const AssetImage('assets/no_profile.png'),
                        fit: BoxFit.cover,
                      ),
                height: UiConsts.largeImageRadius * 2,
                width: UiConsts.largeImageRadius * 2,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(UiConsts.largeImageRadius),
                )),
          ],
        ),
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              CustomColors.primary,
              CustomColors.primaryGradient,
            ]),
      ),
    );
  }
}
