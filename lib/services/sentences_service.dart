import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:t_helper/models/models.dart';

class SentenceService extends ChangeNotifier {
  final String _baseUrl = 't-helper-a0132-default-rtdb.firebaseio.com';
  final List<Sentence> orderedSentences = [];
  final List<Sentence> shuffledSentences = [];

  Sentence currentSentence = Sentence(words: []);
  String stringifiedSentence = '';
  int currentScreen = 0;
  bool isLoading = true;

  void getSentences() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'sentences/uidicoye06/sentences.json');
    final res = await http.get(url);

    final List<dynamic> resSentence = jsonDecode(res.body);

    for (var sentence in resSentence) {
      List<String> stringList = List<String>.from(sentence);
      Sentence newOrderedSentence = Sentence(words: stringList);
      orderedSentences.add(newOrderedSentence);

      List<String> toBeShuffled = [...stringList];

      toBeShuffled.shuffle();

      Sentence newShuffledSentence = Sentence(words: toBeShuffled);
      shuffledSentences.add(newShuffledSentence);

      currentSentence = shuffledSentences[currentScreen];
      stringifiedSentence =
          shuffledSentences[currentScreen].getStringSentence();
    }

    isLoading = false;
    notifyListeners();
  }

  String removeWordAt(int index) {
    String res = currentSentence.words.removeAt(index);
    stringifiedSentence = currentSentence.getStringSentence();
    notifyListeners();

    return res;
  }

  void insertWord(int newIndex, String word) {
    currentSentence.words.insert(newIndex, word);
    stringifiedSentence = currentSentence.getStringSentence();
    notifyListeners();
  }

  void nextScreen() {
    currentScreen += 1;
    currentSentence = shuffledSentences[currentScreen];
    stringifiedSentence = currentSentence.getStringSentence();
    notifyListeners();
  }

  void previousScreen() {
    currentScreen -= 1;
    notifyListeners();
  }
}
