class Activity {
  String? id;
  String? coverImage;
  String name;
  String namedId;
  String description;
  String category;

  Activity({
    this.id,
    this.coverImage,
    required this.name,
    required this.namedId,
    required this.description,
    required this.category,
  });

  factory Activity.fromMap(Map json, String id) => Activity(
        id: id,
        coverImage: json["coverImage"],
        name: json['name'],
        namedId: json['namedId'],
        description: json['description'],
        category: json['category'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "coverImage": coverImage,
        "name": name,
        "namedId": namedId,
        "description": description,
        "category": category,
      };
}
