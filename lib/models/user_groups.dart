import 'package:t_helper/models/models.dart';

class UserGroups {
  String groupId;
  String groupName;
  String groupOwner;
  int groupStudentsNumber;
  String groupSubject;
  String groupSubjectId;
  String? groupPicture;
  String userId;

  UserGroups(
      {required this.groupId,
      required this.groupName,
      required this.groupOwner,
      required this.groupStudentsNumber,
      required this.groupSubject,
      required this.groupSubjectId,
      required this.userId,
      this.groupPicture});

  factory UserGroups.fromMap(Map json) => UserGroups(
        groupId: json["groupId"],
        groupName: json["groupName"],
        groupOwner: json["groupOwner"],
        groupStudentsNumber: json["groupStudentsNumber"],
        groupSubject: json["groupSubject"],
        groupSubjectId: json["groupSubjectId"],
        groupPicture: json["groupPicture"],
        userId: json["userId"],
      );

  factory UserGroups.fromGroupAndUser(Group group, User user) => UserGroups(
        groupId: group.id,
        groupName: group.name,
        groupOwner: group.owner,
        groupStudentsNumber: group.members,
        groupSubject: group.subject['name']!,
        groupSubjectId: group.subject['id']!,
        groupPicture: group.image,
        userId: user.uid,
      );

  Map<String, dynamic> toMap() => {
        "groupId": groupId,
        "groupName": groupName,
        "groupStudentsNumber": groupStudentsNumber,
        "groupSubject": groupSubject,
        "groupOwner": groupOwner,
        "groupSubjectId": groupSubjectId,
        "groupPicture": groupPicture,
        "userId": userId,
      };
}
