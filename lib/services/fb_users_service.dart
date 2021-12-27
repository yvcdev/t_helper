import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t_helper/models/models.dart';
import 'package:t_helper/models/search_users_response.dart';

class FBUsersService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  List<Map<String, dynamic>> _matchedUsers = [];
  String? error;

  Future<List<User>> findUsersByEmail(String query) async {
    final querySnapshot = await users.where('email', isEqualTo: query).get();

    final usersResponse = SearchUsersResponse(users: []);
    for (var doc in querySnapshot.docs) {
      print(doc.data());
      final user = User.fromSnapshot(doc);
      usersResponse.users.add(user);
    }

    return usersResponse.users;
  }
}
