import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/layouts/layouts.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/widgets/widgets.dart';

class ASortSentenceScreen extends StatelessWidget {
  const ASortSentenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActivityFloatingLayoutLayout(
      title: 'Sentence Sorting',
      child: Column(
        children: [
          const SizedBox(height: UiConsts.extraLargeSpacing),
          const Text(
            'Long press to order the sentence',
            style: TextStyle(
                color: Colors.white, fontSize: UiConsts.normalFontSize),
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
                print('da');
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
    final sentence = sentenceService.sentence;

    return ReorderableListView(
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
        sentenceService.stringifySentence();
      },
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
                const EdgeInsets.symmetric(horizontal: UiConsts.normalSpacing),
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: UiConsts.normalFontSize,
                  fontWeight: FontWeight.bold),
            ),
            width: 170,
            height: UiConsts.normalCardHeight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(UiConsts.borderRadius),
                color: Colors.white,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(UiConsts.borderRadius)),
        child: Text(
          sentenceService.sentenceString,
          style: const TextStyle(
              fontSize: UiConsts.largeFontSize, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
