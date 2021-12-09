import 'package:flutter/material.dart';

import 'package:t_helper/widgets/widgets.dart';

class GroupListView extends StatelessWidget {
  const GroupListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return GroupListTile(
          onTap: () {
            print('$index');
          },
        );
      },
    );
  }
}
