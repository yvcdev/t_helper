import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? role;
  final String? profilePic;
  final String? preferredName;
  final List<String>? groups;

  User({
    required this.email,
    required this.uid,
    this.groups,
    this.firstName,
    this.middleName,
    this.lastName,
    this.role,
    this.profilePic,
    this.preferredName,
  });

  @override
  String toString() {
    return 'STRING -> email: $email, '
        'uid: $uid, '
        'firstName: $firstName, '
        'middleName: $middleName, '
        'lastName: $lastName, '
        'role: $role, '
        'profilePic: $profilePic, '
        'preferredName: $preferredName, '
        'groups: ${groups != null ? groups!.length : "No groups"}';
  }

  factory User.fromMap(Map json, String uid) => User(
        email: json["email"],
        uid: uid,
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        role: json["role"],
        profilePic: json["profilePic"],
        preferredName: json["preferredName"],
        //groups: json["groups"],
      );

  factory User.fromSnapshot(DocumentSnapshot snap, String uid) => User(
        email: snap["email"],
        uid: uid,
        firstName: snap["firstName"],
        middleName: snap["middleName"],
        lastName: snap["lastName"],
        role: snap["role"],
        profilePic: snap["profilePic"],
        preferredName: snap["preferredName"],
        //groups: json["groups"]
      );

  Map<String, dynamic> detailsToMap() => {
        "email": email,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "role": role,
        "profilePic": profilePic,
        "preferredName": preferredName,
        "groups": groups
      };
}
