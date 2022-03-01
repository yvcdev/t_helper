import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/helpers/capitalize.dart';
import 'package:t_helper/widgets/widgets.dart';

class RegisteredGroupScreen extends StatelessWidget {
  const RegisteredGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.find();
    UserController userController = Get.find();
    final user = userController.user.value;
    final arguments = Get.arguments;

    return Obx(() => DefaultAppBarLayout(
            title: 'Your Groups',
            topSeparation: false,
            loading: groupController.isLoading.value,
            drawer: arguments?['showDrawer'] ? true : false,
            showAdditionalOptions: user!.role == 'teacher' ? true : false,
            additionalOptions: const [
              'Create group'
            ],
            optionFunctions: {
              'Create group': () async {
                SubjectController subjectController = Get.find();

                UserController userController = Get.find();
                final user = userController.user;

                final userId = user.value!.uid;
                await subjectController.getSubjects(userId, onlyActive: true);

                if (Get.isRegistered<CreateGroupFormController>()) {
                  CreateGroupFormController createGroupFormController =
                      Get.find();
                  createGroupFormController.reset();
                }

                Get.to(() => CreateGroupScreen());
              }
            },
            children: [
              Obx(() {
                if (user.role == 'teacher') {
                  if (groupController.groups.isEmpty) {
                    return const _NoGroups();
                  } else {
                    return const _GroupList();
                  }
                } else {
                  if (groupController.studentGroups.isEmpty) {
                    return const _NoGroups();
                  } else {
                    return const _GroupList();
                  }
                }
              })
            ]));
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GroupController groupController = Get.find();
    List<Group> groups = groupController.groups;
    List<UserGroups> studentGroups = groupController.studentGroups;
    UserController userController = Get.find();
    final user = userController.user.value;
    final role = user!.role;

    bool isTeacher() {
      return role == 'teacher';
    }

    bool useAssetImage(int index) {
      if (isTeacher()) {
        return groups[index].image == null ? true : false;
      } else {
        return studentGroups[index].groupPicture == null ? true : false;
      }
    }

    return Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: isTeacher()
              ? groupController.groups.length
              : groupController.studentGroups.length,
          itemBuilder: (context, index) {
            return Obx(() => CustomListTile(
                  onDismissed: () {},
                  dismissible: false,
                  index: index,
                  title: isTeacher()
                      ? groups[index].name.toTitleCase()
                      : studentGroups[index].groupName.toTitleCase(),
                  subtitle: isTeacher()
                      ? '${groups[index].subject['name']!.toCapitalized()} - '
                          '${groups[index].members == 1 ? "${groups[index].members} student" : "${groups[index].members} students"}'
                      : '${studentGroups[index].groupSubject.toCapitalized()} - '
                          '${studentGroups[index].groupStudentsNumber == 1 ? "${studentGroups[index].groupStudentsNumber} student" : "${studentGroups[index].groupStudentsNumber} students"}',
                  trailing: isTeacher()
                      ? groups[index].image
                      : studentGroups[index].groupPicture,
                  useAssetImage: useAssetImage(index),
                  onTap: () {
                    if (isTeacher()) {
                      CurrentGroupController currentGroupController =
                          Get.find();

                      currentGroupController.currentGroup.value = groups[index];

                      Get.to(() => const GroupInfoScreen());
                    } else {}
                  },
                ));
          },
        ));
  }
}

class _NoGroups extends StatelessWidget {
  const _NoGroups({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();
    final user = userController.user.value;

    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight / 1.2,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            user!.role == 'teacher'
                ? 'You have not created any group yet'
                : 'You are not part of any group yet',
            style: const TextStyle(
              fontSize: UiConsts.normalFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomTextButton(
            onPressed: () {
              if (user.role == 'teacher') {
                registeredGroupsOnCreateGroupTap();
              } else {}
            },
            title: user.role == 'teacher' ? 'Create one?' : 'Join one?',
            fontSize: UiConsts.normalFontSize,
          )
        ],
      )),
    );
  }
}
