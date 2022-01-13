import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/services/services.dart';

groupMembersOnChanged(
    String value, BuildContext context, GlobalKey<FormState> formkey) async {
  final addMemberForm =
      Provider.of<AddMemberFormProvider>(context, listen: false);
  final usersService = Provider.of<FBUsersService>(context, listen: false);
  final groupUsersService =
      Provider.of<FBGroupUsersService>(context, listen: false);
  final currentGroupProvider =
      Provider.of<CurrentGroupProvider>(context, listen: false);

  addMemberForm.email = value.toLowerCase();

  if (addMemberForm.isValidForm(formkey) && addMemberForm.email != '') {
    await groupUsersService.checkUserInGroup(
      currentGroupProvider.currentGroup!.id,
      addMemberForm.email,
    );
    await usersService.findUsersByEmail(addMemberForm.email);
  } else {
    usersService.reset();
  }
}

groupMembersOnTap(BuildContext context) {}

void groupMembersOnDeleteDismiss(
    BuildContext context,
    String groupId,
    String userId,
    GlobalKey<AnimatedListState> globalKey,
    Tween<Offset> offset) async {
  final groupUsersService =
      Provider.of<FBGroupUsersService>(context, listen: false);

  final index = await groupUsersService.removeUserFromGroup(groupId, userId);

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
  final usersService = Provider.of<FBUsersService>(context, listen: false);
  final currentGroupProvider =
      Provider.of<CurrentGroupProvider>(context, listen: false);
  final groupUsersService =
      Provider.of<FBGroupUsersService>(context, listen: false);

  final group = currentGroupProvider.currentGroup;
  final student = usersService.student!;

  final _groupUsers = GroupUsers.fromGroupAndUser(group!, student);

  await groupUsersService.addUserToGroup(_groupUsers);

  if (groupUsersService.error == null) {
    groupUsersService.groupUsersList.add(_groupUsers);
  }

  globalKey.currentState!
      .insertItem(groupUsersService.groupUsersList.length - 1);
  usersService.reset();
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
  final currentGroupProvider =
      Provider.of<CurrentGroupProvider>(context, listen: false);
  final groupUsersService =
      Provider.of<FBGroupUsersService>(context, listen: false);
  final usersService = Provider.of<FBUsersService>(context, listen: false);

  final index = await groupUsersService.removeUserFromGroup(
      currentGroupProvider.currentGroup!.id, student.uid);

  if (index == null) return;

  globalKey.currentState!.removeItem(
      index,
      (_, animation) => SlideTransition(
            position: animation.drive(offset),
          ));
  usersService.reset();
  formController.text = '';
  FocusScope.of(context).unfocus();

  await _updateMembersNumber(
    context,
    currentGroupProvider.currentGroup!.id,
    increment: false,
  );
}

Future _updateMembersNumber(BuildContext context, String groupId,
    {required bool increment}) async {
  final groupService = Provider.of<FBGroupService>(context, listen: false);

  final currentGroupProvider =
      Provider.of<CurrentGroupProvider>(context, listen: false);

  int members = currentGroupProvider.updateMembers(increment: increment);

  await groupService.updateGroup(groupId, "members", members);
}
