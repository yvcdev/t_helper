import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/utils.dart';

class RequestButton extends StatelessWidget {
  final bool isLoading;
  final String waitTitle;
  final String title;
  final Function? onTap;
  final bool? isActive;

  const RequestButton(
      {Key? key,
      required this.isLoading,
      required this.onTap,
      required this.waitTitle,
      required this.title,
      this.isActive = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (isLoading || !isActive!)
          ? null
          : () async {
              onTap!();
            },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConsts.borderRadius),
      ),
      disabledColor: Colors.grey,
      elevation: 0,
      color: CustomColors.primary,
      child: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(UiConsts.normalPadding),
                child: Text(
                  isLoading ? waitTitle : title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: UiConsts.smallFontSize + 2,
                  ),
                )),
            isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
