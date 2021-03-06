import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/services/services.dart';

groupMembersOnChanged(
    String value, BuildContext context, GlobalKey<FormState> formkey) async {
  final addMemberFormController = Get.put(AddMemberFormController());
  UsersController usersController = Get.find();
  GroupUsersController groupUsersController = Get.find();
  CurrentGroupController currentGroupController = Get.find();

  addMemberFormController.email = value.toLowerCase();

  if (addMemberFormController.isValidForm(formkey) &&
      addMemberFormController.email != '') {
    await groupUsersController.checkUserInGroup(
      currentGroupController.currentGroup.value!.id,
      addMemberFormController.email,
    );
    await usersController.findUserByEmail(addMemberFormController.email);
  } else {
    usersController.reset();
  }
}

groupMembersOnTap(BuildContext context) {}

void groupMembersOnDeleteDismiss(
    BuildContext context,
    String groupId,
    String userId,
    GlobalKey<AnimatedListState> globalKey,
    Tween<Offset> offset) async {
  GroupUsersController groupUsersController = Get.find();
  UserGroupsController userGroupsController = Get.find();

  await userGroupsController.removeGroup(groupId, userId);
  final index = await groupUsersController.removeUserFromGroup(groupId, userId);

  if (index == null) return;

  globalKey.currentState!.removeItem(
      index,
      (_, animation) => SlideTransition(
            position: animation.drive(offset),
          ));

  await _updateMembersNumber(
    context,
    groupId,
    increment: false,
  );
}

Future groupMembersOnAddPressed(
    BuildContext context,
    GlobalKey<AnimatedListState> globalKey,
    TextEditingController formController) async {
  UsersController usersController = Get.find();
  CurrentGroupController currentGroupController = Get.find();
  UserGroupsController userGroupsController = Get.find();
  GroupUsersController groupUsersController = Get.find();

  final group = currentGroupController.currentGroup.value;
  final student = usersController.student;

  final _groupUsers = GroupUsers.fromGroupAndUser(group!, student.value!);

  await userGroupsController
      .addGroup(UserGroups.fromGroupAndUser(group, student.value!));
  await groupUsersController.addUserToGroup(_groupUsers);

  globalKey.currentState!
      .insertItem(groupUsersController.groupUsersList.length - 1);
  usersController.reset();
  formController.text = '';
  FocusScope.of(context).unfocus();

  await _updateMembersNumber(
    context,
    group.id,
    increment: true,
  );
}

Future groupMembersOnRemovePressed(
    BuildContext context,
    User student,
    GlobalKey<AnimatedListState> globalKey,
    TextEditingController formController,
    Tween<Offset> offset) async {
  CurrentGroupController currentGroupController = Get.find();
  UserGroupsController userGroupsController = Get.find();
  GroupUsersController groupUsersController = Get.find();
  UsersController usersController = Get.find();

  await userGroupsController.removeGroup(
      currentGroupController.currentGroup.value!.id, student.uid);

  final index = await groupUsersController.removeUserFromGroup(
      currentGroupController.currentGroup.value!.id, student.uid);

  if (index == null) return;

  globalKey.currentState!.removeItem(
      index,
      (_, animation) => SlideTransition(
            position: animation.drive(offset),
          ));
  usersController.reset();
  formController.text = '';
  FocusScope.of(context).unfocus();

  await _updateMembersNumber(
    context,
    currentGroupController.currentGroup.value!.id,
    increment: false,
  );
}

Future _updateMembersNumber(BuildContext context, String groupId,
    {required bool increment}) async {
  GroupController groupController = Get.find();

  CurrentGroupController currentGroupController = Get.find();

  int members = currentGroupController.updateMembers(increment: increment);

  await UserGroupsService()
      .updateStudentNumber(currentGroupController.currentGroup.value!);

  await groupController.updateGroup(groupId, "members", members);
}
