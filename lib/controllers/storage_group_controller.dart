import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:t_helper/services/services.dart';

class StorageGroupController extends GetxController {
  Future<String?> uploadGroupPicture(String path, String groupId) async {
    final response = StorageGroupService().uploadGroupPicture(path, groupId);
    return response;
  }
}
