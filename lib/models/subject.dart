class Subject {
  String name;
  final String owner;
  bool active;

  Subject({
    required this.name,
    required this.owner,
    required this.active,
  });

  factory Subject.fromMap(Map json) => Subject(
        name: json["name"],
        owner: json["owner"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "owner": owner,
        "active": active,
      };
}
