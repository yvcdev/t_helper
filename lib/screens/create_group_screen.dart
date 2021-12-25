import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/request_button.dart';
import 'package:t_helper/helpers/helpers.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
        topSeparation: false,
        title: 'Create Group',
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _UpperPicturePicker(),
                Padding(
                  padding: const EdgeInsets.all(UiConsts.largePadding),
                  child: _CreateGroupForm(),
                )
              ],
            ),
          ),
        ));
  }
}

class _UpperPicturePicker extends StatelessWidget {
  const _UpperPicturePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createGroupForm = Provider.of<CreateGroupFormProvider>(context);

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(boxShadow: [UiConsts.boxShadow]),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          createGroupForm.newPictureFile == null
              ? Image.asset(
                  'assets/no_image.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Image.file(
                  createGroupForm.newPictureFile!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          IconButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);

                if (image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackbar(message: 'No image selected', success: false));
                  return;
                }

                createGroupForm.setSelectedImage(image.path);
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                size: UiConsts.largeFontSize,
              ))
        ],
      ),
    );
  }
}

class _CreateGroupForm extends StatelessWidget {
  _CreateGroupForm({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final createGroupForm = Provider.of<CreateGroupFormProvider>(context);
    final subjects = ['', 'english', 'spanish', 'math three'];
    final levels = ['beginner', 'intermediate', 'advanced'];

    onTap() async {
      FocusScope.of(context).unfocus();
      final groupService = Provider.of<FBGroupService>(context, listen: false);
      final userService = Provider.of<FBUserService>(context, listen: false);
      String? downloadUrl;

      if (createGroupForm.subject == '') {
        ScaffoldMessenger.of(context).showSnackBar(snackbar(
            message: 'A subject needs to be selected', success: false));
        return;
      }

      if (!createGroupForm.isValidForm(formKey)) return;

      createGroupForm.isLoading = true;

      final group = Group(
          name: createGroupForm.name,
          owner: userService.user.uid,
          subject: createGroupForm.subject,
          level: createGroupForm.level,
          members: ['x', 'y'],
          activities: ['c', 'd']);

      final groupId = await groupService.createGroup(group);

      if (groupService.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            snackbar(message: groupService.error!, success: false));
        createGroupForm.isLoading = false;
      } else {
        if (createGroupForm.selectedImage != null) {
          final groupStorageService =
              Provider.of<FBStorageGroup>(context, listen: false);

          downloadUrl = await groupStorageService.uploadGroupPicture(
              createGroupForm.selectedImage!, groupId!);

          if (downloadUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                snackbar(message: groupStorageService.error!, success: false));
            return;
          } else {
            await groupService.updateGroup(groupId, 'image', downloadUrl);

            if (groupService.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  snackbar(message: groupService.error!, success: false));
              createGroupForm.isLoading = false;
            }
          }
        }
        createGroupForm.reset();
        Navigator.pushReplacementNamed(context, Routes.GROUP_INFO,
            arguments: group);
      }
    }

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'The Backyardigans',
                labelText: 'Group Name',
                prefixIcon: Icons.text_fields_rounded),
            validator: (value) {
              String pattern = r'^[a-zA-Z\s]*$';
              RegExp regExp = RegExp(pattern);

              if (value!.length < 3) {
                return 'The group name should have more than 2 letters';
              }
              return regExp.hasMatch(value)
                  ? null
                  : 'Only alphabets and spaces are accepted';
            },
            onChanged: (value) => createGroupForm.name = value,
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Group Level:',
                style: TextStyle(fontSize: 17),
              ),
              DropdownButton<String>(
                  value: createGroupForm.level,
                  items: levels.map((level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(level.toCapitalized()),
                    );
                  }).toList(),
                  onChanged: (level) {
                    createGroupForm.level = level!;
                  }),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subject:',
                style: TextStyle(fontSize: 17),
              ),
              DropdownButton<String>(
                  value: createGroupForm.subject,
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: Text(
                          subject == '' ? 'Select' : subject.toTitleCase()),
                    );
                  }).toList(),
                  onChanged: (subject) {
                    createGroupForm.subject = subject!;
                  }),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          RequestButton(
              waitTitle: 'Please Wait',
              title: 'Create',
              isLoading: createGroupForm.isLoading,
              onTap: createGroupForm.isLoading ? null : () => onTap()),
        ],
      ),
    );
  }
}
