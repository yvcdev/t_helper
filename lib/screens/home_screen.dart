import 'package:flutter/material.dart';

import 'package:t_helper/layouts/layouts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
        title: 'Home',
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          _Row(children: [
            {
              'color': Colors.blue,
              'icon': Icons.create,
              'text': 'Create activity',
              'onTap': () {
                Navigator.pushNamed(context, 'create_activity');
              },
            },
            {
              'color': Colors.orange,
              'icon': Icons.group_add,
              'text': 'Create group',
              'onTap': () {
                Navigator.pushNamed(context, 'create_group');
              },
            }
          ])
        ]));
  }
}

class _Row extends StatelessWidget {
  final List<Map<String, dynamic>> children;

  const _Row({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SingleCard(
          color: children[0]['color'],
          icon: children[0]['icon'],
          text: children[0]['text'],
          onTap: children[0]['onTap'],
        ),
        _SingleCard(
          color: children[1]['color'],
          icon: children[1]['icon'],
          text: children[1]['text'],
          onTap: children[1]['onTap'],
        ),
      ],
    );
  }
}

class _SingleCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function onTap;

  const _SingleCard({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: () => onTap(),
        child: Container(
          height: 120,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 45,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
