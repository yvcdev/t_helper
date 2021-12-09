import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:t_helper/utils/custom_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const _Header(),
          const Divider(
            height: 0.2,
          ),
          SizedBox(
            height: 10,
            child: Container(
              color: CustomColors.primary.withOpacity(0.95),
            ),
          ),
          const _Body(),
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
        color: CustomColors.primary.withOpacity(0.95),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            _ListTile(iconData: Icons.home, route: 'home', title: 'Home'),
            _ListTile(
                iconData: Icons.group,
                route: 'registered_groups',
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
        color: Colors.white,
      ),
      onTap: () {
        routeName == route
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, route);
      },
      title: Text(
        title,
        textAlign: TextAlign.end,
        style: const TextStyle(color: Colors.white, fontSize: 18),
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
          children: const [
            Image(
              width: 100,
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.contain,
            ),
            Expanded(child: SizedBox()),
            CircleAvatar(
              radius: 45,
              foregroundImage: NetworkImage(
                  'https://www.whatsappprofiledpimages.com/wp-content/uploads/2021/08/Profile-Photo-Wallpaper.jpg'),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: CustomColors.primary.withOpacity(0.95),
      ),
    );
  }
}
