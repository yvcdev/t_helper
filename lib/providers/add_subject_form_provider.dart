import 'package:flutter/material.dart';

class AddSubjectFormProvider extends ChangeNotifier {
  String subject = '';
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
    subject = '';
    _isLoading = false;
  }
}
