import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';
import 'package:t_helper/helpers/helpers.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarLayout(
        topSeparation: false,
        title: 'Create Group',
        drawer: false,
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
    final createGroupForm = Get.put(CreateGroupFormController());

    return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(boxShadow: [UiConsts.boxShadow]),
        child: Obx(
          () => Stack(
            children: [
              createGroupForm.newPictureFile.value == null
                  ? Image.asset(
                      'assets/no_image.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    )
                  : Image.file(
                      createGroupForm.newPictureFile.value!,
                      height: 200,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
              const _PickerButton()
            ],
          ),
        ));
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CreateGroupFormController createGroupForm = Get.find();

    return Positioned(
        right: 5,
        bottom: 5,
        child: Obx(() => Row(
              children: [
                createGroupForm.selectedImage.value == null
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: CustomColors.primary,
                        ),
                        child: IconButton(
                            highlightColor: Colors.green,
                            padding: const EdgeInsets.all(5),
                            onPressed: () {
                              createGroupForm.setSelectedImage(null);
                            },
                            icon: const Icon(Icons.close_rounded,
                                size: UiConsts.largeFontSize,
                                color: Colors.white)),
                      ),
                const SizedBox(width: 5),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: CustomColors.primary,
                  ),
                  child: IconButton(
                      highlightColor: Colors.green,
                      padding: const EdgeInsets.all(5),
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        if (image == null) {
                          Snackbar.error(
                              'Image selection', 'No new image selected');
                          return;
                        }

                        createGroupForm.setSelectedImage(image.path);
                      },
                      icon: const Icon(Icons.camera_alt_outlined,
                          size: UiConsts.largeFontSize, color: Colors.white)),
                ),
              ],
            )));
  }
}

class _CreateGroupForm extends StatelessWidget {
  _CreateGroupForm({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    CreateGroupFormController createGroupForm = Get.find();
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
            onChanged: (value) => createGroupForm.name.value = value,
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
                  value: createGroupForm.level.value,
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
                    createGroupForm.level.value = level!;
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
              GetX<SubjectController>(
                builder: (controller) => DropdownButton<String>(
                    value: createGroupForm.subject['id'],
                    items: controller.subjects.map((subject) {
                      return DropdownMenuItem<String>(
                          value: subject['id'],
                          child: Text(
                            subject['name']! == ''
                                ? 'Select'
                                : subject['name']!.toTitleCase(),
                            style: TextStyle(
                                fontSize: 17,
                                color: subject['id'] == 'createSubject'
                                    ? CustomColors.primary
                                    : null),
                          ));
                    }).toList(),
                    onChanged: (subjectId) {
                      if (subjectId == 'createSubject') {
                        createGroupOnSubjectTextTap(context);
                      } else {
                        createGroupForm.subject.value = controller.subjects
                            .where((subject) => subject['id'] == subjectId)
                            .toList()[0];
                      }
                    }),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Obx(() => RequestButton(
              waitTitle: 'Please Wait',
              title: 'Create',
              isLoading: createGroupForm.isLoading.value,
              onTap: createGroupForm.isLoading.value
                  ? null
                  : () => createGroupOnTap(context, formKey))),
        ],
      ),
    );
  }
}
