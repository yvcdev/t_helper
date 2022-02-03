import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/home_wrapper.dart';
import 'package:t_helper/widgets/widgets.dart';

class PersonalInfoSetupScreen extends StatelessWidget {
  const PersonalInfoSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBg(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'My Details',
                      style: TextStyle(
                        color: CustomColors.almostBlack.withOpacity(0.8),
                        fontSize: UiConsts.largeFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _InfoForm(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoForm extends StatelessWidget {
  _InfoForm({Key? key}) : super(key: key);
  final GlobalKey<FormState> personalInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Get.put(PersonalInfoFormController());
    PersonalInfoFormController personalInfoForm = Get.find();

    List<String> roleValues = ['', 'teacher', 'student'];
    List<String> preferredNameValues = ['firstName', 'middleName'];

    return Form(
      key: personalInfoFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const _ProfilePicturePicker(),
          const SizedBox(
            height: 20,
          ),
          Obx(() => DropdownButton<String>(
              value: personalInfoForm.role.value,
              items: roleValues.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child:
                      Text(role == '' ? 'Select role' : role.toCapitalized()),
                );
              }).toList(),
              onChanged: (role) {
                personalInfoForm.role.value = role!;
              })),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
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
            onChanged: (value) => personalInfoForm.firstName = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
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
              personalInfoForm.middleName.value = value;
              if (value.length < 3) {
                personalInfoForm.preferredName.value = 'firstName';
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
                  value: personalInfoForm.preferredName.value,
                  items: preferredNameValues.map((preferredName) {
                    return DropdownMenuItem<String>(
                      value: preferredName,
                      child: Text(preferredName == 'firstName'
                          ? 'first name'
                          : 'middle name'),
                    );
                  }).toList(),
                  onChanged: personalInfoForm.middleName.value.length < 3
                      ? null
                      : (preferredName) {
                          personalInfoForm.preferredName.value = preferredName!;
                        })),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
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
            onChanged: (value) => personalInfoForm.lastName = value,
          ),
          const SizedBox(
            height: 50,
          ),
          Obx(() => RequestButton(
              waitTitle: 'Please Wait',
              title: 'Finish',
              isLoading: personalInfoForm.isLoading.value,
              onTap: personalInfoForm.isLoading.value
                  ? null
                  : () => personalInfoOnTap(context, personalInfoFormKey))),
          const SizedBox(
            height: 20,
          ),
          CustomTextButton(
              onPressed: () async {
                AuthController authController = Get.find();
                await authController.signOut();
                personalInfoForm.reset();
                Get.offAll(() => const HomeWrapper());
              },
              title: 'Log Out')
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
    PersonalInfoFormController personalInfoForm = Get.find();

    _openPicker() async {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        Snackbar.error('Image selection', 'No image selected');
        return;
      }

      personalInfoForm.setSelectedImage(image.path);
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
                  child: personalInfoForm.selectedImage.value == ''
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
                      : SizedBox(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              File(personalInfoForm.selectedImage.value),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            personalInfoForm.selectedImage.value == ''
                ? CustomTextButton(
                    onPressed: () async {
                      await _openPicker();
                    },
                    title: 'Add Profile Picture')
                : CustomTextButton(
                    onPressed: () {
                      personalInfoForm.setSelectedImage('');
                    },
                    title: 'Remove Profile Picture',
                  )
          ],
        ));
  }
}
