import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:t_helper/models/models.dart';

class SearchUsersResponse {
  final List<User> users;

  SearchUsersResponse({required this.users});

  factory SearchUsersResponse.fromSnapshot(
          List<QueryDocumentSnapshot<Object?>> snapshot) =>
      SearchUsersResponse(
        users: List<User>.from(snapshot.map((x) => User.fromSnapshot(x))),
      );
}
