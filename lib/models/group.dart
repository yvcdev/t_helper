import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  Group({
    required this.id,
    required this.name,
    required this.namedId,
    required this.owner,
    required this.subject,
    required this.level,
    required this.members,
    required this.activities,
    this.image,
  });

  final String id;
  final String name;
  final String namedId;
  final String owner;
  final String subject;
  final String level;
  String? image;
  final List<String> members;
  final List<String> activities;

  String toJson() => json.encode(toMap());

  factory Group.fromMap(Map<String, dynamic> json, String id) => Group(
        id: id,
        name: json["name"],
        namedId: json["namedId"],
        owner: json["owner"],
        subject: json["subject"],
        level: json["level"],
        image: json["image"],
        members: List<String>.from(json["members"].map((x) => x)),
        activities: List<String>.from(json["activities"].map((x) => x)),
      );

  factory Group.fromSnapshot(
          QueryDocumentSnapshot<Object?> snapshot, String id) =>
      Group(
        id: id,
        name: snapshot["name"],
        namedId: snapshot["namedId"],
        owner: snapshot["owner"],
        subject: snapshot["subject"],
        level: snapshot["level"],
        image: snapshot["image"],
        members: List<String>.from(snapshot["members"].map((x) => x)),
        activities: List<String>.from(snapshot["activities"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "namedId": namedId,
        "owner": owner,
        "subject": subject,
        "level": level,
        'image': image,
        "members": List<dynamic>.from(members.map((x) => x)),
        "activities": List<dynamic>.from(activities.map((x) => x)),
      };
}
