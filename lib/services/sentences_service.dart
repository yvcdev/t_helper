import 'package:get/instance_manager.dart';
import 'package:http/http.dart' as http;
import 'package:t_helper/controllers/sentence_controller.dart';
import 'package:t_helper/helpers/helpers.dart';
import 'dart:convert';

import 'package:t_helper/models/models.dart';

class SentenceService {
  final String _baseUrl = 't-helper-a0132-default-rtdb.firebaseio.com';
  SentenceController c = Get.find();

  Future getSentences() async {
    try {
      c.isLoading.value = true;

      final url = Uri.https(_baseUrl, 'sentences/uidicoye06/sentences.json');
      final res = await http.get(url);

      final List<dynamic> resSentence = jsonDecode(res.body);

      for (var sentence in resSentence) {
        List<String> stringList = List<String>.from(sentence);
        Sentence newOrderedSentence = Sentence(words: stringList);
        c.orderedSentences.add(newOrderedSentence);

        List<String> toBeShuffled = [...stringList];

        toBeShuffled.shuffle();

        Sentence newShuffledSentence = Sentence(words: toBeShuffled);
        c.shuffledSentences.add(newShuffledSentence);

        c.currentSentence.value = c.shuffledSentences[c.currentScreen];
        c.stringifiedSentence.value =
            c.shuffledSentences[c.currentScreen].getStringSentence();
      }

      c.isLoading.value = false;
    } catch (e) {
      Snackbar.error(
          'Unknown error', 'Error getting the sentences for the activity');
    }
  }
}
