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
          _Header(scaffoldKey: scaffoldKey),
          _Body(scaffoldKey: scaffoldKey),
          _Footer(scaffoldKey: scaffoldKey, authController: authController)
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key? key,
    required this.scaffoldKey,
    required this.authController,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              CustomColors.primary,
              CustomColors.primaryGradient,
            ]),
      ),
      alignment: Alignment.centerRight,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _ListTile(
              scaffoldKey: scaffoldKey,
              iconData: Icons.logout,
              iconColor: Colors.white,
              textColor: Colors.white,
              onTap: () async {
                await authController.signOut();
              },
              title: 'Sign Out'),
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 20, right: 10),
            child: const Image(
              height: 30,
              image: AssetImage(
                'assets/logo/logo.png',
              ),
            ),
          ),
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
    AuthController authController = AuthController();
    String route = Get.currentRoute;

    if (!authController.auth.currentUser!.emailVerified) {
      return Expanded(
        child: Column(
          children: [
            _ListTile(
                scaffoldKey: scaffoldKey,
                iconData: Icons.alternate_email_rounded,
                onTap: () {
                  if (route == '/EditEmailPasswordScreen') {
                    Get.back();
                  } else {
                    Get.back();
                    Get.to(() => const EditEmailPasswordScreen());
                  }
                },
                title: 'Change Email'),
            _ListTile(
                scaffoldKey: scaffoldKey,
                iconData: Icons.mark_email_unread,
                onTap: () {
                  if (route == '/HomeWrapper') {
                    Get.back();
                  } else {
                    Get.offAll(() => const HomeWrapper());
                  }
                },
                title: 'Verify Email'),
          ],
        ),
      );
    }

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
  final Color? iconColor;
  final Color? textColor;

  const _ListTile(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.scaffoldKey,
      required this.onTap,
      this.iconColor,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 10),
      trailing: Icon(
        iconData,
        color: iconColor ?? CustomColors.primaryGradient,
        size: UiConsts.largeFontSize,
      ),
      onTap: () {
        onTap();
      },
      title: Text(
        title,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: textColor ?? CustomColors.almostBlack,
          fontSize: UiConsts.normalFontSize - 4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _Header({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    AuthController authController = Get.find();
    String route = Get.currentRoute;
    final user = userController.user;

    return SizedBox(
      height: 200,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                top: authController.auth.currentUser!.emailVerified ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              user.value.preferredName! == 'firstName'
                                  ? '${user.value.firstName!} ${user.value.lastName!}'
                                  : '${user.value.middleName!} ${user.value.lastName!}',
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: UiConsts.normalFontSize),
                            ),
                            Text(
                              user.value.email,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: UiConsts.normalFontSize - 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: user.value.profilePic == null
                              ? Image.asset('assets/no_profile.png')
                              : FadeInImage(
                                  image: NetworkImage(user.value.profilePic!),
                                  placeholder:
                                      const AssetImage('assets/no_profile.png'),
                                  fit: BoxFit.cover,
                                ),
                          height: UiConsts.largeImageRadius * 2,
                          width: UiConsts.largeImageRadius * 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                UiConsts.largeImageRadius),
                          )),
                    ],
                  ),
                ),
                authController.auth.currentUser!.emailVerified
                    ? _ListTile(
                        scaffoldKey: scaffoldKey,
                        iconData: Icons.edit,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                        onTap: () {
                          if (route == '/EditPersonalInfoScreen') {
                            Get.back();
                          } else {
                            Get.offAll(() => const EditPersonalInfoScreen());
                          }
                        },
                        title: 'Edit Details')
                    : const SizedBox(),
              ],
            ),
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
      ),
    );
  }
}
