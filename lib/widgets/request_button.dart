import 'package:flutter/material.dart';
import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/utils/utils.dart';

class RequestButton extends StatelessWidget {
  final bool isLoading;
  final String waitTitle;
  final String title;
  final onTap;

  const RequestButton(
      {Key? key,
      required this.isLoading,
      required this.onTap,
      required this.waitTitle,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isLoading
          ? null
          : () async {
              /*FocusScope.of(context).unfocus();
                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;

                    loginForm.isLoading = true;

                    final String? errorMessage = await authService.login(
                        loginForm.email, loginForm.password);

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      NotificationsService.showSnackBar(
                          message: 'Credenciales incorrectas', success: false);
                      loginForm.isLoading = false;
                    }*/
            },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UiConsts.borderRadius),
      ),
      disabledColor: Colors.grey,
      elevation: 0,
      color: CustomColors.primary,
      child: Container(
          width: 140,
          padding: const EdgeInsets.all(UiConsts.normalPadding),
          child: Text(
            isLoading ? waitTitle : title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: UiConsts.smallFontSize + 2,
            ),
          )),
    );
  }
}
