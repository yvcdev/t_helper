import 'dart:io';

import 'package:flutter/material.dart';

class PersonalInfoFormProvider extends ChangeNotifier {
  String? selectedImage;
  File? newPictureFile;
  String firstName = '';
  String lastName = '';

  String _middleName = '';
  String get middleName => _middleName;
  set middleName(String middleName) {
    _middleName = middleName;
    print(firstName);
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _role = '';
  String get role => _role;
  set role(String role) {
    _role = role;
    notifyListeners();
  }

  String _preferredName = 'firstName';
  String get preferredName => _preferredName;
  set preferredName(String role) {
    _preferredName = role;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    print('Form reset');
    firstName = '';
    lastName = '';
    middleName = '';
    preferredName = 'firstName';
    role = '';
    selectedImage = null;
    _isLoading = false;
  }

  void setSelectedImage(String? path) {
    selectedImage = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }
}
