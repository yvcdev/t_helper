import 'package:get/get.dart';
import 'package:t_helper/controllers/user_controller.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/group_service.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  var isLoading = false.obs;
  UserController userController = Get.find();
  @override
  onReady() {
    groups.bindStream(GroupService().getGroups(userController.user.value));
    super.onReady();
  }

  Stream<List<Group>> getGroups(User user) {
    final response = GroupService().getGroups(user);
    return response;
  }

  Future<String?> createGroup(Group group) async {
    final response = await GroupService().createGroup(group);
    return response;
  }

  Future<String?> updateGroup(String id, String field, dynamic value) async {
    final response = await GroupService().updateGroup(id, field, value);
    return response;
  }

  Future deleteGroup(String groupId, String imageUrl) async {
    await GroupService().deleteGroup(groupId, imageUrl);
  }
}
