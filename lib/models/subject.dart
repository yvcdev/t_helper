class Subject {
  String name;
  String namedId;
  final String owner;
  String? id;
  bool active;

  Subject({
    this.id,
    required this.name,
    required this.owner,
    required this.active,
    required this.namedId,
  });

  factory Subject.fromMap(Map json) => Subject(
        name: json["name"],
        namedId: json["namedId"],
        owner: json["owner"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "namedId": namedId,
        "owner": owner,
        "active": active,
      };
}
