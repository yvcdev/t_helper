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
    Text text(String text) => Text(text,
        textAlign: TextAlign.end,
        style: const TextStyle(color: Colors.white, fontSize: 18));

    Icon icon(IconData iconData) => Icon(
          iconData,
          color: Colors.white,
        );

    return Expanded(
      child: Container(
        color: CustomColors.primary.withOpacity(0.95),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              trailing: icon(Icons.home),
              onTap: () {
                //Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              },
              title: text('Home'),
            ),
            ListTile(
              trailing: icon(Icons.party_mode),
              onTap: () {},
              title: text('Party people'),
            ),
            ListTile(
              trailing: icon(Icons.people),
              onTap: () {},
              title: text('People'),
            ),
            ListTile(
              trailing: icon(Icons.settings),
              onTap: () {
                //Navigator.pushReplacementNamed(context, SettingsScreen.routeName);
              },
              title: text('Ajustes'),
            ),
          ],
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
      child: const Image(
        image: AssetImage('assets/logo.png'),
        fit: BoxFit.contain,
      ),
      decoration: BoxDecoration(
        color: CustomColors.primary.withOpacity(0.95),
      ),
    );
  }
}
