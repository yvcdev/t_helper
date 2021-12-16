import 'dart:convert';

class User {
  final String email;
  final String uid;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? role;
  final String? profilePic;
  final String? preferredName;

  User({
    required this.email,
    required this.uid,
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
        'preferredName: $preferredName, ';
  }

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  factory User.fromMap(Map<String, dynamic> json) => User(
        email: json["email"],
        uid: json["uid"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        role: json["role"],
        profilePic: json["profilePic"],
        preferredName: json["preferredName"],
      );
}
