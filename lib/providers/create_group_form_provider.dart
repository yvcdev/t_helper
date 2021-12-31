import 'dart:io';

import 'package:flutter/material.dart';

class CreateGroupFormProvider extends ChangeNotifier {
  String _name = '';
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  String? groupId;

  String? selectedImage;
  File? newPictureFile;

  String _subject = '';
  String get subject => _subject;
  set subject(String subject) {
    _subject = subject;
    notifyListeners();
  }

  String _level = 'beginner';
  String get level => _level;
  set level(String level) {
    _level = level;
    notifyListeners();
  }

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
    name = '';
    subject = '';
    selectedImage = null;
    newPictureFile = null;
    level = 'beginner';
    _isLoading = false;
  }

  void setSelectedImage(String? path) {
    selectedImage = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  String getGroupId() {
    List<String> _formattedNameList = name.split(' ');
    String _formattedName = _formattedNameList.join('').toLowerCase();
    print(_formattedName.length);
    if (_formattedName.length > 25) {
      groupId = _formattedName.substring(0, 24);
    } else {
      groupId = _formattedName;
    }
    return groupId ?? '';
  }
}