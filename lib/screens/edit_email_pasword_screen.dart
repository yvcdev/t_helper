import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/functions/functions.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class EditEmailPasswordScreen extends StatelessWidget {
  const EditEmailPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find();

    return DefaultAppBarLayout(
        topSeparation: false,
        showActionButton: false,
        drawer: false,
        title: 'My Details',
        children: [
          Padding(
            padding: const EdgeInsets.all(UiConsts.normalPadding),
            child: Column(
              children: [
                Text(
                  'Current Email',
                  style: TextStyle(
                      fontSize: UiConsts.smallFontSize,
                      color: Colors.black.withOpacity(0.8)),
                ),
                Text(
                  userController.user.value.email,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: UiConsts.normalFontSize, color: Colors.black),
                ),
                const SizedBox(
                  height: 15,
                ),
                const _InfoForm(),
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
  final GlobalKey<FormState> editEmailPasswordFormKey = GlobalKey<FormState>();
  final editEmailPasswordForm = Get.put(EditEmailPasswordFormController());
  TextEditingController newEmailController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: editEmailPasswordFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: newEmailController,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'johndoe@email.com',
                labelText: 'New Email',
                prefixIcon: Icons.alternate_email_outlined),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);

              if (value!.isEmpty) return null;

              return regExp.hasMatch(value)
                  ? null
                  : 'This does not look like an email';
            },
            onChanged: (value) => editEmailPasswordForm.newEmail.value = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: currentPasswordController,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.generalInputDecoration(
                hintText: '******',
                labelText: 'Current Password',
                prefixIcon: Icons.lock_outline),
            validator: (value) {
              if (value!.isEmpty) return null;

              if (value.length >= 6) return null;

              return 'Password should have more than 6 characters';
            },
            onChanged: (value) =>
                editEmailPasswordForm.newPassword.value = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
              controller: newPasswordController,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.generalInputDecoration(
                  hintText: '******',
                  labelText: 'New Password',
                  prefixIcon: Icons.lock_outline),
              validator: (value) {
                if (value! == '') {
                  if (currentPasswordController.text != '') {
                    return 'A new password must be provided';
                  }
                  return null;
                }

                if (currentPasswordController.text == value) {
                  return 'Current and new passwords must be different';
                }

                if (value.length >= 6) return null;

                return 'Password should have more than 6 characters';
              },
              onChanged: (value) {
                editEmailPasswordForm.newPassword.value = value;
              }),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: confirmPasswordController,
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.generalInputDecoration(
                hintText: '******',
                labelText: 'Confirm Password',
                prefixIcon: Icons.lock_outline),
            validator: (value) {
              if (value! == '') {
                if (newPasswordController.text != '') {
                  return 'New password needs confirmation';
                }
                return null;
              }
              if (value != editEmailPasswordForm.newPassword.value) {
                return 'Password fields must match';
              }
              return null;
            },
            onChanged: (value) =>
                editEmailPasswordForm.confirmPassword.value = value,
          ),
          const SizedBox(
            height: 35,
          ),
          Obx(() => RequestButton(
              waitTitle: 'Please Wait',
              title: editEmailPasswordForm.updateButtonText.value,
              isLoading: editEmailPasswordForm.isLoading.value,
              isActive: !editEmailPasswordForm.isSaved.value,
              onTap: (editEmailPasswordForm.isLoading.value ||
                      editEmailPasswordForm.isSaved.value)
                  ? null
                  : () {
                      editEmailPasswordShowDialog(
                          editEmailPasswordFormKey, context);
                    })),
          const SizedBox(
            height: 10,
          ),
          Obx(() => Visibility(
                visible: !editEmailPasswordForm.isSaved.value,
                child: CustomTextButton(
                    onPressed: () {
                      newEmailController.clear();
                      currentPasswordController.clear();
                      newPasswordController.clear();
                      confirmPasswordController.clear();
                      editEmailPasswordForm.reset();
                      FocusScope.of(context).unfocus();
                    },
                    title: 'Cancel'),
              )),
        ],
      ),
    );
  }
}
