import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/custom_colors.dart';

class AddUserSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Student\'s email';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query == '') {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Text('BuildLeading');
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('BuildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(UiConsts.normalPadding),
        child: const Center(
          child: Text(
            'Type a student\'s email, then select the person to be added',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UiConsts.normalFontSize,
              color: CustomColors.primary,
            ),
          ),
        ),
      );
    }

    final usersService = Provider.of<FBUsersService>(context, listen: false);

    return Text('');
  }
}
