import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/models/models.dart';
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
                    ChangeNotifierProvider(
                      create: (_) => PersonalInfoFormProvider(),
                      child: const _InfoForm(),
                    ),
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
  const _InfoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey =
        GlobalKey<FormState>(debugLabel: 'personal_info_key');
    final personalInfoForm = Provider.of<PersonalInfoFormProvider>(context);

    List<String> roleValues = ['', 'teacher', 'student'];
    List<String> preferredNameValues = ['firstName', 'middleName'];

    onTap() async {
      FocusScope.of(context).unfocus();

      final userService = Provider.of<FBUserService>(context, listen: false);
      final user = userService.user;
      String? downloadUrl;

      if (personalInfoForm.role == '') {
        ScaffoldMessenger.of(context).showSnackBar(
            snackbar(message: 'A role needs to be selected', success: false));
        return;
      }
      if (!personalInfoForm.isValidForm(formKey)) return;

      if (personalInfoForm.selectedImage != null) {
        final userStorageService =
            Provider.of<FBStorageUser>(context, listen: false);

        downloadUrl = await userStorageService.uploadProfilePicture(
            personalInfoForm.selectedImage!, user.uid);

        if (downloadUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              snackbar(message: userStorageService.error!, success: false));
          return;
        } else {}
      }

      User userToSend = User(
        email: user.email,
        uid: user.uid,
        firstName: personalInfoForm.firstName,
        middleName: personalInfoForm.middleName,
        lastName: personalInfoForm.lastName,
        preferredName: personalInfoForm.preferredName,
        role: personalInfoForm.role,
        profilePic: downloadUrl,
      );

      personalInfoForm.isLoading = true;

      await userService.createUpdateUserInfo(userToSend);

      if (userService.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            snackbar(message: userService.error!, success: false));
        personalInfoForm.isLoading = false;
      } else {
        personalInfoForm.reset();
        Navigator.pushReplacementNamed(context, Routes.HOME);
      }
    }

    return Form(
      key: formKey,
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
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'Jhon',
                labelText: 'First Name',
                prefixIcon: Icons.person),
            validator: (value) {
              String pattern = r'^[a-zA-Z]{3,20}$';
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
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'Anders',
                labelText: 'Middle Name',
                prefixIcon: Icons.person),
            validator: (value) {
              if (value != '') {
                String pattern = r'^[a-zA-Z]{3,20}$';
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
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'Doe',
                labelText: 'Last Name',
                prefixIcon: Icons.person),
            validator: (value) {
              String pattern = r'^[a-zA-Z]{3,20}$';
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'Your last name can only have letters (3-20)';
            },
            onChanged: (value) => personalInfoForm.lastName = value,
          ),
          const SizedBox(
            height: 30,
          ),
          RequestButton(
              waitTitle: 'Please Wait',
              title: 'Finish',
              isLoading: personalInfoForm.isLoading,
              onTap: personalInfoForm.isLoading ? null : () => onTap()),
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
              color: personalInfoForm.selectedImage == null
                  ? Colors.transparent
                  : CustomColors.primary,
              width: personalInfoForm.selectedImage == null ? 0 : 3,
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
              child: Stack(
                children: [
                  personalInfoForm.selectedImage == null
                      ? const SizedBox(
                          height: 100,
                          width: 100,
                          child: Icon(
                            Icons.person,
                            size: 90,
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
                  personalInfoForm.selectedImage == null
                      ? const Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.add_rounded,
                            size: 32,
                          ))
                      : const SizedBox()
                ],
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
