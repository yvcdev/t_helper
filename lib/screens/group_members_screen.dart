import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

import 'package:t_helper/widgets/widgets.dart';

class GroupMembersScreen extends StatelessWidget {
  GroupMembersScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addMemberForm = Provider.of<AddMemberFormProvider>(context);
    final groupUsersService = Provider.of<FBGroupUsersService>(context);

    Tween<Offset> _offset =
        Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

    return NotificationsAppBarLayout(
        scroll: false,
        colunmLayout: true,
        topSeparation: false,
        title: 'Group Members',
        loading: groupUsersService.loading,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: UiConsts.largePadding,
                left: UiConsts.largePadding,
                right: UiConsts.largePadding),
            decoration: BoxDecoration(
                color: Colors.white, boxShadow: [UiConsts.boxShadow]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find a user and add them to the group',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: UiConsts.smallFontSize, color: Colors.black),
                ),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    controller: emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.generalInputDecoration(
                        hintText: 'johndoe@gmail.com',
                        labelText: 'Studet\'s Email',
                        prefixIcon: Icons.alternate_email_outlined),
                    validator: (value) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = RegExp(pattern);

                      if (emailController.text != '') {
                        return regExp.hasMatch(value ?? '')
                            ? null
                            : 'This does not look like an email';
                      }
                    },
                    onChanged: (value) {
                      _onChanged(value, context, formKey);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _UserInfoSection(
                  userInGroup: groupUsersService.userInGroup,
                  addMemberForm: addMemberForm,
                  globalKey: _listKey,
                  formController: emailController,
                  offset: _offset,
                )
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: groupUsersService.groupUsersList.length,
              itemBuilder: (context, index, animation) {
                final groupUsers = groupUsersService.groupUsersList[index];
                String fullName = groupUsers.userMiddleName == ''
                    ? '${groupUsers.userFirstName} ${groupUsers.userLastName}'
                    : '${groupUsers.userFirstName} ${groupUsers.userMiddleName} ${groupUsers.userLastName}';
                return SlideTransition(
                  position: animation.drive(_offset),
                  child: GroupInfoListTile(
                    onDeleteDismiss: () async {
                      _onDeleteDismiss(context, groupUsers.groupId,
                          groupUsers.userId, _listKey, _offset);
                    },
                    index: index,
                    title: fullName,
                    subtitle: groupUsers.userEmail,
                    trailing: groupUsers.userProfilePic,
                    useAssetImage:
                        groupUsers.userProfilePic == null ? true : false,
                    assetImageName: 'no_profile.png',
                    onTap: () {
                      _onTap(context);
                    },
                  ),
                );
              },
            ),
          ),
        ]);
  }

  _onChanged(
      String value, BuildContext context, GlobalKey<FormState> formkey) async {
    final addMemberForm =
        Provider.of<AddMemberFormProvider>(context, listen: false);
    final usersService = Provider.of<FBUsersService>(context, listen: false);
    final groupUsersService =
        Provider.of<FBGroupUsersService>(context, listen: false);
    final currentGroupProvider =
        Provider.of<CurrentGroupProvider>(context, listen: false);

    addMemberForm.email = value.toLowerCase();

    if (addMemberForm.isValidForm(formKey) && addMemberForm.email != '') {
      await groupUsersService.checkUserInGroup(
        currentGroupProvider.currentGroup!.id,
        addMemberForm.email,
      );
      await usersService.findUsersByEmail(addMemberForm.email);
    } else {
      usersService.reset();
    }
  }

  _onTap(BuildContext context) {}

  void _onDeleteDismiss(BuildContext context, String groupId, String userId,
      GlobalKey<AnimatedListState> globalKey, Tween<Offset> offset) async {
    final groupUsersService =
        Provider.of<FBGroupUsersService>(context, listen: false);

    final index = await groupUsersService.removeUserFromGroup(groupId, userId);

    if (index == null) return;

    globalKey.currentState!.removeItem(
        index,
        (_, animation) => SlideTransition(
              position: animation.drive(offset),
            ));
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({
    Key? key,
    required this.addMemberForm,
    required this.globalKey,
    required this.userInGroup,
    required this.formController,
    required this.offset,
  }) : super(key: key);

  final AddMemberFormProvider addMemberForm;
  final GlobalKey<AnimatedListState> globalKey;
  final bool userInGroup;
  final TextEditingController formController;
  final Tween<Offset> offset;

  @override
  Widget build(BuildContext context) {
    final usersService = Provider.of<FBUsersService>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    if (usersService.error != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: UiConsts.largePadding),
        child: Text(
          usersService.error!,
          style: const TextStyle(color: CustomColors.red),
        ),
      );
    }

    if (usersService.message != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: UiConsts.largePadding),
        child: Text(
          usersService.message!,
          style: const TextStyle(color: CustomColors.red),
        ),
      );
    }

    if (usersService.student != null) {
      User student = usersService.student!;
      String fullName = student.middleName == ""
          ? '${student.firstName} ${student.lastName}'
          : '${student.firstName} ${student.middleName} ${student.lastName}';
      return Padding(
        padding: const EdgeInsets.only(bottom: UiConsts.largePadding),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInGroup ? 'Student already in group' : 'Found student',
                  style: TextStyle(
                      color:
                          userInGroup ? CustomColors.red : CustomColors.green,
                      fontSize: UiConsts.tinyFontSize),
                ),
                SizedBox(
                  width: screenWidth -
                      (UiConsts.largePadding * 2) -
                      UiConsts.normalFontSize -
                      28,
                  child: Text(
                    fullName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: UiConsts.normalFontSize),
                  ),
                ),
                SizedBox(
                  width: screenWidth -
                      (UiConsts.largePadding * 2) -
                      UiConsts.normalFontSize -
                      28,
                  child: Text(
                    student.email,
                    style: const TextStyle(
                        color: CustomColors.almostBlack,
                        fontSize: UiConsts.tinyFontSize),
                  ),
                )
              ],
            ),
            const Spacer(),
            userInGroup
                ? IconButton(
                    onPressed: () async {
                      await _onRemovePressed(context, student);
                    },
                    icon: const Icon(Icons.delete_forever,
                        color: CustomColors.almostBlack,
                        size: UiConsts.largeFontSize))
                : IconButton(
                    onPressed: () async {
                      await _onAddPressed(context);
                    },
                    icon: const Icon(Icons.person_add_alt_rounded,
                        color: CustomColors.almostBlack,
                        size: UiConsts.largeFontSize))
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Future _onAddPressed(BuildContext context) async {
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
  }

  Future _onRemovePressed(BuildContext context, User student) async {
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
  }
}
