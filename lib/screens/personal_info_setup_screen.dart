import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/helpers/capitalize.dart';
import 'package:t_helper/utils/utils.dart';
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
    final personalInfoForm = Provider.of<PersonalInfoFormProvider>(context);

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
          DropdownButton<String>(
              value: personalInfoForm.role,
              items: roleValues.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child:
                      Text(role == '' ? 'Select role' : role.toCapitalized()),
                );
              }).toList(),
              onChanged: (role) {
                personalInfoForm.role = role!;
              }),
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
            onChanged: (value) => personalInfoForm.middleName = value,
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
              DropdownButton<String>(
                  value: personalInfoForm.preferredName,
                  items: preferredNameValues.map((preferredName) {
                    return DropdownMenuItem<String>(
                      value: preferredName,
                      child: Text(preferredName == 'firstName'
                          ? 'first name'
                          : 'middle name'),
                    );
                  }).toList(),
                  onChanged: personalInfoForm.middleName.length < 3
                      ? null
                      : (preferredName) {
                          personalInfoForm.preferredName = preferredName!;
                        }),
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
          RequestButton(
              waitTitle: 'Please Wait',
              title: 'Finish',
              isLoading: personalInfoForm.isLoading,
              onTap: personalInfoForm.isLoading
                  ? null
                  : () => personalInfoOnTap(context, personalInfoFormKey)),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  CustomColors.primary.withOpacity(0.1),
                ),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            onPressed: () async {
              final authService =
                  Provider.of<FBAuthService>(context, listen: false);
              await authService.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.HOME, (Route<dynamic> route) => false);
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                  color: CustomColors.primary,
                  fontSize: UiConsts.smallFontSize),
            ),
          ),
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
    final personalInfoForm = Provider.of<PersonalInfoFormProvider>(context);

    return Column(
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
                final ImagePicker _picker = ImagePicker();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);

                if (image == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackbar(message: 'No image selected', success: false));
                  return;
                }

                personalInfoForm.setSelectedImage(image.path);
              },
              borderRadius: BorderRadius.circular(50),
              child: personalInfoForm.selectedImage == null
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
                          File(personalInfoForm.selectedImage!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        personalInfoForm.selectedImage == null
            ? const SizedBox()
            : IconButton(
                onPressed: () {
                  personalInfoForm.setSelectedImage(null);
                },
                icon: const Icon(
                  Icons.close,
                  size: 32,
                  color: CustomColors.primary,
                ))
      ],
    );
  }
}
