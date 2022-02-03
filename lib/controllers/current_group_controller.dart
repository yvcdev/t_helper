import 'package:get/get.dart';
import 'package:t_helper/models/group.dart';

class CurrentGroupController extends GetxController {
  Rx<Group?> currentGroup = Rx(null);

  int updateMembers({required bool increment}) {
    if (currentGroup.value!.members < 0) return 0;
    if (increment) {
      currentGroup.value!.members = currentGroup.value!.members + 1;
      return currentGroup.value!.members;
    } else {
      currentGroup.value!.members = currentGroup.value!.members - 1;
      return currentGroup.value!.members;
    }
  }
}
