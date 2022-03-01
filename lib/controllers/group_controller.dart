import 'package:get/get.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/services/group_service.dart';

class GroupController extends GetxController {
  var groups = <Group>[].obs;
  var studentGroups = <UserGroups>[].obs;
  var isLoading = true.obs;
  UserController userController = Get.find();
  @override
  onReady() async {
    if (userController.user.value!.role == 'teacher') {
      groups.bindStream(GroupService().getGroups(userController.user.value!));
      isLoading.value = false;
    } else {
      Get.lazyPut(() => UserGroupsController(), fenix: true);

      UserGroupsController userGroupsController = Get.find();
      studentGroups.value = await userGroupsController
          .getUserGroups(userController.user.value!.uid);

      isLoading.value = false;
    }
    super.onReady();
  }

  void reset() {
    groups.value = [];
    isLoading.value = false;
  }

  Future<String?> createGroup(Group group) async {
    final response = await GroupService().createGroup(group);
    return response;
  }

  Future<String?> updateGroup(String id, String field, dynamic value) async {
    final response = await GroupService().updateGroup(id, field, value);
    return response;
  }

  Future<String?> updateGroupNoImage(Group group) async {
    final response = await GroupService().updateGroupNoImage(group);
    return response;
  }

  Future<String?> updateGroupWithImage(Group group) async {
    final response = await GroupService().updateGroupWithImage(group);
    return response;
  }

  Future deleteGroup(String groupId, String imageUrl) async {
    await GroupService().deleteGroup(groupId, imageUrl);
  }

  Future<bool> deletePicture(String imageUrl) async {
    final response = await GroupService().deletePicture(imageUrl);
    return response;
  }

  Future<Group?> getGroup(String groupId) async {
    final response = await GroupService().getGroup(groupId);
    return response;
  }
}
