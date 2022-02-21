import 'dart:math';

import 'package:get/instance_manager.dart';

import 'package:t_helper/controllers/controllers.dart';

String generateUniqueId(String name, int sequence, String character) {
  UserController userController = Get.find();
  final now = DateTime.now();
  String year = '${now.year}'.substring(2, 4);
  String second =
      '${now.second}'.length == 1 ? '0${now.second}' : '${now.second}';
  String day = '${now.day}'.length == 1 ? '0${now.day}' : '${now.day}';
  String firstLetter = name.trim()[0];
  String lastLetter = name.trim()[name.length - 1];
  String sequenceString = sequence < 10 ? '0$sequence' : '$sequence';
  String randomNumber = '${Random().nextInt(9)}';

  String id = character +
      sequenceString +
      randomNumber +
      firstLetter +
      userController.user.value.uid.substring(0, 2) +
      lastLetter +
      year +
      second +
      day;

  return id;
}
