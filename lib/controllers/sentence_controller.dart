import 'package:get/get.dart';
import 'package:t_helper/models/sentence.dart';
import 'package:t_helper/services/sentences_service.dart';

class SentenceController extends GetxController {
  final List<Sentence> orderedSentences = [];
  final List<Sentence> shuffledSentences = [];
  var currentSentence = Sentence(words: []).obs;
  var stringifiedSentence = ''.obs;
  int currentScreen = 0;
  var isLoading = true.obs;

  Future getSentences() async {
    await SentenceService().getSentences();
  }

  String removeWordAt(int index) {
    String res = currentSentence.value.words.removeAt(index);
    stringifiedSentence.value = currentSentence.value.getStringSentence();

    return res;
  }

  void insertWord(int newIndex, String word) {
    currentSentence.value.words.insert(newIndex, word);
    stringifiedSentence.value = currentSentence.value.getStringSentence();
  }

  void nextScreen() {
    currentScreen += 1;
    currentSentence.value = shuffledSentences[currentScreen];
    stringifiedSentence.value = currentSentence.value.getStringSentence();
  }

  void previousScreen() {
    currentScreen -= 1;
  }
}
