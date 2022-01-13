import 'package:flutter/material.dart';
import 'package:t_helper/models/group.dart';

class CurrentGroupProvider extends ChangeNotifier {
  Group? currentGroup;

  int updateMembers({required bool increment}) {
    if (currentGroup!.members < 0) return 0;
    if (increment) {
      currentGroup!.members = currentGroup!.members + 1;
      notifyListeners();
      return currentGroup!.members;
    } else {
      currentGroup!.members = currentGroup!.members - 1;
      notifyListeners();
      return currentGroup!.members;
    }
  }
}
