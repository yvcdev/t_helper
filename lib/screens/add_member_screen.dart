import 'package:flutter/material.dart';
import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/layouts/layouts.dart';

import 'package:t_helper/search/search.dart';
import 'package:t_helper/utils/custom_colors.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionAppBarLayout(
      actionIcon: const Icon(Icons.person_add_alt_rounded),
      onActionPressed: () {
        _showAddUserSearch(context);
      },
      title: 'Add Member',
      children: [],
    );
  }

  Future<dynamic> _showAddUserSearch(BuildContext context) =>
      showSearch(context: context, delegate: AddUserSearchDelegate());
}
