import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/helpers/helpers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';

personalInfoOnTap(BuildContext context, GlobalKey<FormState> formKey) async {
  FocusScope.of(context).unfocus();

  final userService = Provider.of<FBUserService>(context, listen: false);
  final personalInfoForm =
      Provider.of<PersonalInfoFormProvider>(context, listen: false);
  final user = userService.user;
  String? downloadUrl;

  if (personalInfoForm.role == '') {
    ScaffoldMessenger.of(context).showSnackBar(
        snackbar(message: 'A role needs to be selected', success: false));
    return;
  }
  if (!personalInfoForm.isValidForm(formKey)) return;

  personalInfoForm.isLoading = true;

  if (personalInfoForm.selectedImage != null) {
    final userStorageService =
        Provider.of<FBStorageUser>(context, listen: false);

    downloadUrl = await userStorageService.uploadProfilePicture(
        personalInfoForm.selectedImage!, user.uid);

    if (downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          snackbar(message: userStorageService.error!, success: false));
      return;
    }
  }

  User userToSend = User(
      email: user.email,
      uid: user.uid,
      firstName: personalInfoForm.firstName.toCapitalized(),
      middleName: personalInfoForm.middleName.toCapitalized(),
      lastName: personalInfoForm.lastName.toCapitalized(),
      preferredName: personalInfoForm.preferredName,
      role: personalInfoForm.role,
      profilePic: downloadUrl,
      groups: []);

  personalInfoForm.isLoading = true;

  await userService.createUserInfo(userToSend);

  if (userService.error != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(snackbar(message: userService.error!, success: false));
    personalInfoForm.isLoading = false;
  } else {
    personalInfoForm.reset();
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }
}
