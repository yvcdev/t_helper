import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/custom_colors.dart';
import 'package:t_helper/utils/utils.dart';
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
          const Text(
            'Long press a card to order the sentence',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontSize: UiConsts.normalFontSize),
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

                customPopup(
                    context: context,
                    correct: correct,
                    onTap: () {
                      if (correct &&
                          sentenceService.currentScreen + 1 <
                              sentenceService.shuffledSentences.length) {
                        sentenceService.nextScreen();
                        Navigator.pop(context);
                      } else if (sentenceService.currentScreen + 1 >=
                          sentenceService.shuffledSentences.length) {
                        Navigator.pushReplacementNamed(
                            context, Routes.FINISHED_SCREEN);
                      }
                    });
              },
              title: 'Okay! Let\'s check'),
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
                color: CustomColors.almostBlack,
                fontSize: UiConsts.normalFontSize,
              ),
            ),
            height: UiConsts.normalCardHeight,
            decoration: BoxDecoration(
                border: Border.all(
                    color: CustomColors.secondary.withOpacity(0.6), width: 1),
                borderRadius: BorderRadius.circular(UiConsts.borderRadius),
                color: CustomColors.almostWhite,
                boxShadow: [UiConsts.boxShadow]),
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
            color: CustomColors.secondary.withOpacity(0.9),
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
