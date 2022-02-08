import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/screens/screens.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class EditPersonalInfoScreen extends StatelessWidget {
  const EditPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultAppBarLayout(
        topSeparation: false,
        showActionButton: false,
        title: 'My Details',
        children: [
          Padding(
            padding: const EdgeInsets.all(UiConsts.normalPadding),
            child: Column(
              children: const [
                _InfoForm(),
              ],
            ),
          ),
        ]);
  }
}

class _InfoForm extends StatefulWidget {
  const _InfoForm({Key? key}) : super(key: key);

  @override
  State<_InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<_InfoForm> {
  final GlobalKey<FormState> editInfoFormKey = GlobalKey<FormState>();
  final editInfoForm = Get.put(EditInfoFormController());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController preferredNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = editInfoForm.firstName.value;
    middleNameController.text = editInfoForm.middleName.value;
    lastNameController.text = editInfoForm.lastName.value;
  }

  @override
  Widget build(BuildContext context) {
    List<String> preferredNameValues = [
      'firstName',
      'middleName'
    ]; //TODO: change this to get the info from a const in
    //another file in persona info screen too

    return Form(
      key: editInfoFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const _ProfilePicturePicker(),
          CustomTextButton(
              onPressed: () {
                Get.to(() => const EditEmailPasswordScreen());
              },
              title: 'Update email or password'),
          TextFormField(
            controller: firstNameController,
            autocorrect: false,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'Jhon',
                labelText: 'First Name',
                prefixIcon: Icons.text_fields_rounded),
            validator: (value) {
              String pattern = r'^[a-zA-ZñÑ]{3,20}$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Your fisrt name can only have letters (3-20)';
            },
            onChanged: (value) => editInfoForm.firstName.value = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: middleNameController,
            autocorrect: false,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'Anders',
                labelText: 'Middle Name',
                prefixIcon: Icons.text_fields_rounded),
            validator: (value) {
              if (value != '') {
                String pattern = r'^[a-zA-ZñÑ]{3,20}$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Your middle name can only have letters (3-20)';
              }
            },
            onChanged: (value) {
              editInfoForm.middleName.value = value;
              if (value.length < 3) {
                editInfoForm.preferredName.value = 'firstName';
              }
            },
          ),
          const SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Preferred name:',
                style: TextStyle(fontSize: 17),
              ),
              Obx(() => DropdownButton<String>(
                  value: editInfoForm.preferredName.value,
                  items: preferredNameValues.map((preferredName) {
                    return DropdownMenuItem<String>(
                      value: preferredName,
                      child: Text(preferredName == 'firstName'
                          ? 'first name'
                          : 'middle name'),
                    );
                  }).toList(),
                  onChanged: editInfoForm.middleName.value.length < 3
                      ? null
                      : (preferredName) {
                          editInfoForm.preferredName.value = preferredName!;
                        })),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: lastNameController,
            autocorrect: false,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'Doe',
                labelText: 'Last Name',
                prefixIcon: Icons.text_fields_rounded),
            validator: (value) {
              String pattern = r'^[a-zA-ZñÑ]{3,20}$';
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Your last name can only have letters (3-20)';
            },
            onChanged: (value) => editInfoForm.lastName.value = value,
          ),
          const SizedBox(
            height: 50,
          ),
          Obx(() => RequestButton(
              waitTitle: 'Please Wait',
              title: 'Save',
              isLoading: editInfoForm.isLoading.value,
              isActive: !editInfoForm.isSaved.value,
              onTap: (editInfoForm.isLoading.value ||
                      editInfoForm.isSaved.value)
                  ? null
                  : () => editPersonalInfoOnUpdate(editInfoFormKey, context))),
          const SizedBox(
            height: 10,
          ),
          Obx(() => Visibility(
                visible: !editInfoForm.isSaved.value,
                child: CustomTextButton(
                    onPressed: () {
                      editInfoForm.populate();
                      firstNameController.text = editInfoForm.firstName.value;
                      middleNameController.text = editInfoForm.middleName.value;
                      lastNameController.text = editInfoForm.lastName.value;
                      FocusScope.of(context).unfocus();
                    },
                    title: 'Cancel'),
              )),
        ],
      ),
    );
  }
}

class _ProfilePicturePicker extends StatelessWidget {
  const _ProfilePicturePicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editInfoForm = Get.put(EditInfoFormController());

    _openPicker() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        Snackbar.error('Image selection', 'No new image selected');
        return;
      }

      editInfoForm.setSelectedImage(image.path);
    }

    return Obx(() => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey,
                border: Border.all(
                  color: CustomColors.primary,
                  width: 3,
                ),
              ),
              height: 100,
              width: 100,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await _openPicker();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: editInfoForm.selectedImage.value == ''
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/no_profile.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : editInfoForm.selectedImage.value.startsWith('http')
                          ? SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  editInfoForm.selectedImage.value,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(editInfoForm.selectedImage.value),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            editInfoForm.selectedImage.value == ''
                ? CustomTextButton(
                    onPressed: () async {
                      await _openPicker();
                    },
                    title: 'Add Profile Picture')
                : CustomTextButton(
                    onPressed: () {
                      editInfoForm.setSelectedImage('');
                    },
                    title: 'Remove Profile Picture',
                  )
          ],
        ));
  }
}
