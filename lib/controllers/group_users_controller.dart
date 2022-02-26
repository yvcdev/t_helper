import 'package:get/get.dart';

import 'package:t_helper/models/group_users.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/services.dart';

class GroupUsersController extends GetxController {
  var groupUsersList = <GroupUsers>[].obs;
  var loading = true.obs;
  var userInGroup = false.obs;

  Future<bool> checkUserInGroup(String groupId, String userEmail) async {
    final response =
        await GroupUsersService().checkUserInGroup(groupId, userEmail);
    return response;
  }

  Future<int?> removeUserFromGroup(String groupId, String userId) async {
    final response =
        await GroupUsersService().removeUserFromGroup(groupId, userId);
    return response;
  }

  Future addUserToGroup(GroupUsers groupUsers) async {
    await GroupUsersService().addUserToGroup(groupUsers);
  }

  Future<List<GroupUsers>> getGroupUsers(String groupId) async {
    final response = await GroupUsersService().getGroupUsers(groupId);
    return response;
  }

  Future<bool> updateUserInfo(User user) async {
    final response = await GroupUsersService().updateUserInfo(user);
    return response;
  }
}
