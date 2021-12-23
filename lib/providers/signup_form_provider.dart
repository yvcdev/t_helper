import 'package:flutter/material.dart';

class SignupFormProvider extends ChangeNotifier {
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    email = '';
    password = '';
    confirmPassword = '';
    _isLoading = false;
  }
}
