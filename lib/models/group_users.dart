import 'package:t_helper/models/models.dart';

class GroupUsers {
  String groupId;
  String userId;
  String userEmail;
  String userFirstName;
  String? userMiddleName;
  String userLastName;
  String? userProfilePic;

  GroupUsers({
    required this.groupId,
    required this.userId,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    this.userMiddleName,
    this.userProfilePic,
  });

  factory GroupUsers.fromMap(Map json) => GroupUsers(
        groupId: json["groupId"],
        userId: json["userId"],
        userEmail: json["userEmail"],
        userFirstName: json["userFirstName"],
        userLastName: json["userLastName"],
        userMiddleName: json["userMiddleName"],
        userProfilePic: json["userProfilePic"],
      );

  factory GroupUsers.fromGroupAndUser(Group group, User user) => GroupUsers(
        groupId: group.id,
        userId: user.uid,
        userEmail: user.email,
        userFirstName: user.firstName!,
        userLastName: user.lastName!,
        userMiddleName: user.middleName ?? '',
        userProfilePic: user.profilePic,
      );

  Map<String, dynamic> toMap() => {
        "groupId": groupId,
        "userId": userId,
        "userEmail": userEmail,
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userMiddleName": userMiddleName,
        "userProfilePic": userProfilePic,
      };
}
