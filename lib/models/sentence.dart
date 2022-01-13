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
    List<String> withoutSpace = [',', '!', '.', ';', ':'];

    String sentence = "";

    for (var word in words) {
      if (withoutSpace.contains(word)) {
        sentence = '$sentence$word';
      } else {
        sentence = '$sentence $word';
      }
    }

    return sentence;
  }
}
