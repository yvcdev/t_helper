import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/custom_colors.dart';
import 'package:t_helper/widgets/custom_accept_button.dart';

Future customPopup({
  required BuildContext context,
  required bool correct,
  required Function onTap,
  String label = 'Continue',
}) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UiConsts.borderRadius),
          ),
          child: Container(
            color: Colors.transparent,
            height: 265,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _Container(
                  correct: correct,
                  label: label,
                  onTap: () {
                    onTap();
                  },
                ),
                _Image(correct: correct)
              ],
            ),
          ),
        );
      });
}

class _Container extends StatelessWidget {
  final bool correct;
  final String? correctText;
  final String? incorrectText;
  final String label;
  final Function onTap;

  const _Container(
      {Key? key,
      required this.correct,
      this.correctText = 'You did a great job!',
      this.incorrectText = 'Ups, that was incorrect!',
      required this.label,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: UiConsts.largeImageRadius + 20),
      padding: const EdgeInsets.only(
        top: UiConsts.largeImageRadius + 40,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          UiConsts.borderRadius,
        ),
      ),
      child: Column(
        children: [
          Text(
            correct ? correctText! : incorrectText!,
            style: const TextStyle(
              fontSize: UiConsts.normalFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          CustomAcceptButton(
            onTap: () {
              onTap();
            },
            title: label,
            shadow: false,
            fontSize: UiConsts.smallFontSize,
            color: correct ? CustomColors.green : CustomColors.red,
          )
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final bool correct;

  const _Image({Key? key, required this.correct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UiConsts.largeImageRadius * 3,
      width: UiConsts.largeImageRadius * 3,
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
          left: UiConsts.largeImageRadius / (correct ? 4 : 3),
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
