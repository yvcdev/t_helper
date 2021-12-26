import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/screens/loading_screen.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/helpers/capitalize.dart';
import 'package:t_helper/widgets/widgets.dart';

class RegisteredGroupScreen extends StatelessWidget {
  const RegisteredGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupService = Provider.of<FBGroupService>(context);
    final userService = Provider.of<FBUserService>(context);

    return NotificationsAppBarLayout(
        title: 'Your Groups',
        topSeparation: false,
        children: [
          FutureBuilder(
              future: groupService.getGroups(userService.user),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Group>?> snapshot) {
                if (snapshot.hasData) {
                  if (groupService.groups!.isEmpty) {
                    return const _NoGroups();
                  } else {
                    return _GroupList(groupService: groupService);
                  }
                } else {
                  return const LoadingScreen(
                    useScafold: false,
                  );
                }
              }),
        ]);
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList({
    Key? key,
    required this.groupService,
  }) : super(key: key);

  final FBGroupService groupService;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: groupService.groups!.length,
      itemBuilder: (context, index) {
        List<Group> groups = groupService.groups!;
        return GroupInfoListTile(
          index: index,
          title: groups[index].name.toTitleCase(),
          subtitle: '${groups[index].subject.toCapitalized()} - '
              '${groups[index].members.length == 1 ? "${groups[index].members.length} member" : "${groups[index].members.length} members"}',
          trailing: groups[index].image,
          useAssetImage: groups[index].image == null ? true : false,
          onTap: () {
            Navigator.pushNamed(context, Routes.GROUP_INFO,
                arguments: groups[index]);
          },
        );
      },
    );
  }
}

class _NoGroups extends StatelessWidget {
  const _NoGroups({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'You haven\'t created any group yet',
          style: TextStyle(
            fontSize: UiConsts.normalFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        CustomTextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.CREATE_GROUP);
            },
            title: 'Create one?',
            fontSize: UiConsts.normalFontSize)
      ],
    ));
  }
}
