import 'package:get/get.dart';

import 'package:t_helper/models/user_groups.dart';
import 'package:t_helper/services/services.dart';

class UserGroupsController extends GetxController {
  var userGroupsList = <UserGroups>[].obs;
  var loading = true.obs;

  Future<int?> removeGroup(String groupId, String userId) async {
    final response = await UserGroupsService().removeGroup(groupId, userId);
    return response;
  }

  Future addGroup(UserGroups userGroups) async {
    await UserGroupsService().addGroup(userGroups);
  }

  Future<List<UserGroups>> getUserGroups(String userId) async {
    final response = await UserGroupsService().getUserGroups(userId);
    return response;
  }
}
