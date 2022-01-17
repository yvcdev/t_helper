import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/services/fb_subject_service.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';
import 'package:t_helper/helpers/helpers.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationsAppBarLayout(
        topSeparation: false,
        title: 'Create Group',
        children: [
          Column(
            children: [
              const _UpperPicturePicker(),
              Padding(
                padding: const EdgeInsets.all(UiConsts.largePadding),
                child: _CreateGroupForm(),
              )
            ],
          )
        ]);
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
        children: [
          createGroupForm.newPictureFile == null
              ? Image.asset(
                  'assets/no_image.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                )
              : Image.file(
                  createGroupForm.newPictureFile!,
                  height: 200,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          _PickerButton(createGroupForm: createGroupForm)
        ],
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    Key? key,
    required this.createGroupForm,
  }) : super(key: key);

  final CreateGroupFormProvider createGroupForm;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      bottom: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: CustomColors.primary,
        ),
        child: IconButton(
            highlightColor: Colors.green,
            padding: const EdgeInsets.all(5),
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
            icon: const Icon(Icons.camera_alt_outlined,
                size: UiConsts.largeFontSize, color: Colors.white)),
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
    final subjectsService = Provider.of<FBSubjectService>(context);
    final subjects = [
      {
        "name": '',
        "id": '',
      }
    ];

    for (var subject in subjectsService.subjectList) {
      subjects.add({"name": subject.name, "id": subject.id!});
    }

    final levels = ['beginner', 'intermediate', 'advanced'];

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            inputFormatters: [LengthLimitingTextInputFormatter(25)],
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'The Backyardigans',
                labelText: 'Group Name',
                prefixIcon: Icons.text_fields_rounded),
            validator: (value) {
              String pattern = r'^[a-zA-Z1-9ñÑ\s]*$';
              RegExp regExp = RegExp(pattern);

              if (value!.length < 3) {
                return 'The group name should have more than 2 letters';
              }
              return regExp.hasMatch(value)
                  ? null
                  : 'Only alphanumerics and spaces are accepted';
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
                'Generated ID:',
                style: TextStyle(fontSize: 17),
              ),
              Text(
                createGroupForm.getGroupId(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
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
                      child: Text(
                        level.toCapitalized(),
                        style: const TextStyle(fontSize: 17),
                      ),
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
                  value: createGroupForm.subject['id'],
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                        value: subject['id'],
                        child: Text(
                          subject['name']! == ''
                              ? 'Select'
                              : subject['name']!.toTitleCase(),
                          style: const TextStyle(fontSize: 17),
                        ));
                  }).toList(),
                  onChanged: (subjectId) {
                    createGroupForm.subject = subjects
                        .where((subject) => subject['id'] == subjectId)
                        .toList()[0];
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
              onTap: createGroupForm.isLoading
                  ? null
                  : () => createGroupOnTap(context, formKey)),
        ],
      ),
    );
  }
}
