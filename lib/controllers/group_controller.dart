import 'package:get/state_manager.dart';
import 'package:t_helper/models/group.dart';
import 'package:t_helper/models/user.dart';
import 'package:t_helper/services/group_service.dart';

class GroupController extends GetxController {
  Rx<List<Group>?> groups = Rx(null);

  Future<List<Group>?> getGroups(User user) async {
    final response = await GroupService().getGroups(user);
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
