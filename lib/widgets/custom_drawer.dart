import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/utils/custom_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: const [
          _Header(),
          _Body(),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: CustomColors.almostWhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _ListTile(
                iconData: Icons.home,
                route: Routes.TEACHER_HOME,
                title: 'Home'),
            _ListTile(
                iconData: Icons.group,
                route: Routes.REGISTERED_GROUPS,
                title: 'Your Groups'),
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String route;

  const _ListTile({
    Key? key,
    required this.iconData,
    required this.title,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? routeName = ModalRoute.of(context)!.settings.name;

    return ListTile(
      trailing: Icon(
        iconData,
        color: CustomColors.primaryGradient,
        size: UiConsts.largeFontSize,
      ),
      onTap: () {
        routeName == route
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, route);
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
    return DrawerHeader(
      margin: EdgeInsets.zero,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Image(
              width: 100,
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.contain,
            ),
            const Expanded(child: SizedBox()),
            Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const FadeInImage(
                  image: NetworkImage(
                      'https://www.whatsappprofiledpimages.com/wp-content/uploads/2021/08/Profile-Photo-Wallpaper.jpg'),
                  placeholder: AssetImage('assets/no_image.jpg'),
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
