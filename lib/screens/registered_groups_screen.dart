import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/controllers/group_controller.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/helpers/capitalize.dart';
import 'package:t_helper/widgets/widgets.dart';

class RegisteredGroupScreen extends StatelessWidget {
  const RegisteredGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupController = Get.put(GroupController());
    UserController userController = Get.find();
    final user = userController.user;

    return DefaultAppBarLayout(
        title: 'Your Groups',
        topSeparation: false,
        children: [
          FutureBuilder(
              future: groupController.getGroups(user.value),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Group>?> snapshot) {
                if (snapshot.hasData) {
                  if (groupController.groups.value!.isEmpty) {
                    return const _NoGroups();
                  } else {
                    return const _GroupList();
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.find();

    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: groupController.groups.value!.length,
      itemBuilder: (context, index) {
        List<Group> groups = groupController.groups.value!;
        return CustomListTile(
          onDismissed: () {},
          dismissible: false,
          index: index,
          title: groups[index].name.toTitleCase(),
          subtitle: '${groups[index].subject['name']!.toCapitalized()} - '
              '${groups[index].members == 1 ? "${groups[index].members} student" : "${groups[index].members} students"}',
          trailing: groups[index].image,
          useAssetImage: groups[index].image == null ? true : false,
          onTap: () {
            CurrentGroupController currentGroupController = Get.find();

            currentGroupController.currentGroup.value = groups[index];

            Get.to(() => const GroupInfoScreen());
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
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight - 130,
      child: Center(
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
              registeredGroupsOnCreateGroupTap();
            },
            title: 'Create one?',
            fontSize: UiConsts.normalFontSize,
          )
        ],
      )),
    );
  }
}
