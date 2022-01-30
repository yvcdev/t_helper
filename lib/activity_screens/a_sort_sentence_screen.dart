import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/custom_colors.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/home_wrapper.dart';
import 'package:t_helper/widgets/widgets.dart';

class ASortSentenceScreen extends StatelessWidget {
  const ASortSentenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sentenceService = Provider.of<SentenceService>(context);

    return ActivityFloatingLayoutLayout(
      loading: sentenceService.isLoading,
      title: 'Sentence Sorting',
      child: Column(
        children: [
          const SizedBox(height: UiConsts.normalSpacing),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Long-press a word, then drag it left or right to order the sentence',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: UiConsts.smallFontSize,
              ),
            ),
          ),
          const SizedBox(
            height: UiConsts.largeSpacing,
          ),
          const SizedBox(
              height: UiConsts.normalCardHeight, child: _ReordableList()),
          const _SentenceCreatedContainer(),
          const SizedBox(
            height: UiConsts.normalSpacing,
          ),
          CustomAcceptButton(
            onTap: () {
              final currentSentece =
                  sentenceService.currentSentence.getStringSentence();
              final correctSentence = sentenceService
                  .orderedSentences[sentenceService.currentScreen]
                  .getStringSentence();

              bool correct = correctSentence == currentSentece;

              if (correct &&
                  sentenceService.currentScreen + 1 >=
                      sentenceService.shuffledSentences.length) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => MinimalPopUp(
                        topImage: true,
                        correct: correct,
                        correctText: 'Awesome! We\'ve finished',
                        acceptButtonLabel: 'Finish',
                        onAccept: () {
                          Get.offAll(() => const HomeWrapper());
                        }));
              } else {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => MinimalPopUp(
                        topImage: true,
                        correct: correct,
                        acceptButtonColor:
                            correct ? CustomColors.green : CustomColors.red,
                        onAccept: () {
                          if (correct &&
                              sentenceService.currentScreen + 1 <
                                  sentenceService.shuffledSentences.length) {
                            sentenceService.nextScreen();
                            Get.back();
                          } else {
                            Get.back();
                          }
                        }));
              }
            },
            title: 'Okay! Let\'s check',
            shadow: false,
          ),
          const SizedBox(
            height: UiConsts.normalSpacing,
          ),
        ],
      ),
    );
  }
}

class _ReordableList extends StatelessWidget {
  const _ReordableList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sentenceService = Provider.of<SentenceService>(context);
    final sentence = sentenceService.currentSentence;

    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: ReorderableListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int index = 0; index < sentence.words.length; index++)
            _WordCard(
              text: sentence.words[index],
              key: Key('$index'),
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final word = sentenceService.removeWordAt(oldIndex);
          sentenceService.insertWord(newIndex, word);
        },
      ),
    );
  }
}

class _WordCard extends StatelessWidget {
  final String text;

  const _WordCard({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(UiConsts.normalPadding),
            margin:
                const EdgeInsets.symmetric(horizontal: UiConsts.smallSpacing),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: UiConsts.normalFontSize,
              ),
            ),
            height: UiConsts.normalCardHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UiConsts.borderRadius),
                color: CustomColors.secondary),
          ),
        ),
        const SizedBox(
          height: UiConsts.normalSpacing,
        )
      ],
    );
  }
}

class _SentenceCreatedContainer extends StatelessWidget {
  const _SentenceCreatedContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sentenceService = Provider.of<SentenceService>(context);

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(UiConsts.smallSpacing),
        padding: const EdgeInsets.all(UiConsts.largePadding),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: CustomColors.primary,
            borderRadius: BorderRadius.circular(UiConsts.borderRadius)),
        child: Text(
          sentenceService.stringifiedSentence,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontSize: UiConsts.largeFontSize,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
