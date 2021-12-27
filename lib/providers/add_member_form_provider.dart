import 'package:flutter/material.dart';

class AddMemberFormProvider extends ChangeNotifier {
  String email = '';
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
    _isLoading = false;
  }
}
