import 'dart:convert';

class Sentence {
  final List<String> words;

  Sentence({required this.words});

  factory Sentence.dynamic(List<dynamic> words) {
    List<String> stringList = List<String>.from(words);
    return Sentence(words: stringList);
  }

  factory Sentence.shuffledWords(List<String> words) {
    words.shuffle();
    return Sentence(words: words);
  }

  String getStringSentence() {
    return words.join(" ");
  }
}
