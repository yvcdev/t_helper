import 'dart:convert';

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
  int members;
  final List<String> activities;

  String toJson() => json.encode(toMap());

  factory Group.fromMap(Map json, String id) => Group(
        id: id,
        name: json["name"],
        namedId: json["namedId"],
        owner: json["owner"],
        subject: json["subject"],
        level: json["level"],
        image: json["image"],
        members: json["members"],
        activities: List<String>.from(json["activities"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "namedId": namedId,
        "owner": owner,
        "subject": subject,
        "level": level,
        'image': image,
        "members": members,
        "activities": List<dynamic>.from(activities.map((x) => x)),
      };
}
