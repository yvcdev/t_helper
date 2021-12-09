import 'dart:convert';

class Sentence {
  Sentence({
    required this.words,
  });
  List<String> words;

  factory Sentence.fromJson(String str) => Sentence.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sentence.fromMap(Map<String, dynamic> json) => Sentence(
        words: List<String>.from(json["sentence"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "sentence": List<dynamic>.from(words.map((x) => x)),
      };
}
