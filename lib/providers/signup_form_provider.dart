import 'package:flutter/material.dart';

class SignupFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void reset() {
    email = '';
    password = '';
    confirmPassword = '';
    _isLoading = false;
  }
}
