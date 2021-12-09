import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:t_helper/models/models.dart';

class SentenceService extends ChangeNotifier {
  final String _baseUrl = 't-helper-a0132-default-rtdb.firebaseio.com';
  final List<Sentence> sentences = [];

  final Sentence createdSentence = Sentence(words: []);

  Sentence sentence = Sentence(words: ['My', 'name', 'is', 'Yeison']);
  String sentenceString = '';

  bool isLoading = true;
  Color bgColor = Colors.transparent;

  Future<Sentence> getSentence(index) async {
    isLoading = true;
    notifyListeners();

    final url =
        Uri.https(_baseUrl, 'sentences/uidicoye06/sentences/$index.json');
    final res = await http.get(url);

    final List<dynamic> resSentence = jsonDecode(res.body);
    final List<String> stringList = List<String>.from(resSentence);

    sentence = Sentence(words: stringList);

    isLoading = false;
    notifyListeners();

    return sentence;
  }

  addWordCreatedSentence(String word) {
    createdSentence.words.add(word);
    notifyListeners();
  }

  stringifySentence() {
    sentenceString = sentence.words.join(" ");
    notifyListeners();
  }

  String removeWordAt(int index) {
    return sentence.words.removeAt(index);
  }

  void insertWord(int newIndex, String word) {
    sentence.words.insert(newIndex, word);
  }
}
