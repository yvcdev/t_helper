import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/screens/loading_screen.dart';
import 'package:t_helper/services/fb_users_service.dart';
import 'package:t_helper/utils/utils.dart';

import 'package:t_helper/widgets/widgets.dart';

class GroupMembersScreen extends StatelessWidget {
  GroupMembersScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final addMemberForm = Provider.of<AddMemberFormProvider>(context);
    final usersService = Provider.of<FBUsersService>(context);

    if (usersService.loading) return const LoadingScreen();

    return NotificationsAppBarLayout(
        scroll: false,
        colunmLayout: true,
        topSeparation: false,
        title: 'Group Members',
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

                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'This does not look like an email';
                    },
                    onChanged: (value) {
                      _onChanged(value, context, formKey);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _UserInfoSection(addMemberForm: addMemberForm)
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return GroupInfoListTile(
                  index: index,
                  title: 'Student Name',
                  subtitle: 'Student Email',
                  trailing:
                      'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg?size=626&ext=jpg',
                  onTap: () {},
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

    addMemberForm.email = value;

    if (addMemberForm.isValidForm(formKey)) {
      await usersService.findUsersByEmail(addMemberForm.email);
    } else {
      usersService.reset();
    }
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({
    Key? key,
    required this.addMemberForm,
  }) : super(key: key);

  final AddMemberFormProvider addMemberForm;

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
    ;
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
                const Text(
                  'Found student',
                  style: TextStyle(
                      color: CustomColors.green,
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
            IconButton(
                onPressed: () {
                  usersService.reset();
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
}
