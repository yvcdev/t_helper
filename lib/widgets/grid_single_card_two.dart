import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/widgets/widgets.dart';

class GridSingleCardTwo extends StatelessWidget {
  final List<Map<String, dynamic>> cards;

  const GridSingleCardTwo({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleCard(
                  icon: cards[index]['icon'],
                  text: cards[index]['text'],
                  onTap: cards[index]['onTap'],
                  color: cards[index]['color'],
                  index: index,
                ),
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: UiConsts.normalSpacing,
          mainAxisExtent: UiConsts.normalCardHeight,
        ));
  }
}
