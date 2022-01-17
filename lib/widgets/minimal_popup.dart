import 'package:flutter/material.dart';
import 'package:t_helper/constants/ui.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class MinimalPopUp extends StatelessWidget {
  final bool topImage;
  final bool? correct;
  final String correctText;
  final String incorrectText;
  final String? description;
  final Function onAccept;
  final Function? onCancel;
  final String? acceptButtonLabel;
  final String? cancelButtonLabel;
  final Color? acceptButtonColor;
  final Color? cancelButtonColor;
  final Color? descriptionColor;

  const MinimalPopUp({
    Key? key,
    required this.topImage,
    required this.onAccept,
    this.correct = true,
    this.correctText = 'You did a great job!',
    this.incorrectText = 'Ups, that was incorrect!',
    this.onCancel,
    this.acceptButtonLabel,
    this.cancelButtonLabel,
    this.acceptButtonColor,
    this.cancelButtonColor,
    this.description,
    this.descriptionColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _Content(
            description: description,
            descriptionColor: descriptionColor,
            topImage: topImage,
            correct: correct!,
            incorrectText: incorrectText,
            correctText: correctText,
            onAccept: onAccept,
            onCancel: onCancel,
            acceptButtonLabel: acceptButtonLabel,
            cancelButtonLabel: cancelButtonLabel,
            acceptButtonColor: acceptButtonColor,
            cancelButtonColor: cancelButtonColor,
          ),
          topImage
              ? _TopImage(
                  correct: correct!,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class _TopImage extends StatelessWidget {
  final bool correct;

  const _TopImage({Key? key, required this.correct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UiConsts.largeImageRadius * 2.5,
      width: UiConsts.largeImageRadius * 2.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          UiConsts.largeImageRadius * 1.5,
        ),
        border: Border.all(
          color: correct ? CustomColors.green : CustomColors.red,
          width: 2,
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: UiConsts.largeImageRadius / 3,
          bottom: UiConsts.largeImageRadius / 3,
          left: UiConsts.largeImageRadius / (correct ? 3 : 3),
          right: UiConsts.largeImageRadius / (correct ? 1.5 : 3),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
          UiConsts.largeImageRadius * 1.5,
        )),
        child: Image.asset(
          'assets/${correct ? 'win' : 'fail'}.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool topImage;
  final bool correct;
  final Function onAccept;
  final Function? onCancel;
  final String? acceptButtonLabel;
  final String? cancelButtonLabel;
  final Color? acceptButtonColor;
  final Color? cancelButtonColor;
  final String? description;
  final Color? descriptionColor;

  final String correctText;
  final String incorrectText;
  const _Content({
    Key? key,
    required this.topImage,
    required this.correct,
    required this.correctText,
    required this.incorrectText,
    required this.onAccept,
    this.onCancel,
    this.acceptButtonLabel = 'Continue',
    this.cancelButtonLabel = 'Cancel',
    this.acceptButtonColor,
    this.cancelButtonColor,
    required this.description,
    required this.descriptionColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
          top: UiConsts.largeImageRadius * 1.25,
        ),
        padding: EdgeInsets.only(
          top: UiConsts.normalPadding +
              (topImage ? UiConsts.largeImageRadius * 1.25 : 0),
          bottom: UiConsts.normalPadding,
          left: UiConsts.normalPadding,
          right: UiConsts.normalPadding,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(UiConsts.borderRadius)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              correct ? correctText : incorrectText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: UiConsts.normalFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: description == null ? 0 : 20),
            description == null
                ? const SizedBox(height: 0)
                : Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: descriptionColor ?? Colors.black,
                      fontSize: UiConsts.smallFontSize,
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAcceptButton(
                  onTap: () {
                    onAccept();
                  },
                  title: acceptButtonLabel ?? 'Continue',
                  shadow: false,
                  fontSize: UiConsts.smallFontSize,
                  color: acceptButtonColor,
                ),
                SizedBox(width: (onCancel == null) ? 0 : 20),
                (onCancel == null)
                    ? const SizedBox()
                    : CustomAcceptButton(
                        shadow: false,
                        fontSize: UiConsts.smallFontSize,
                        color: cancelButtonColor,
                        onTap: () {
                          onCancel!();
                        },
                        title: cancelButtonLabel ?? 'Cancel')
              ],
            ),
          ],
        ));
  }
}
