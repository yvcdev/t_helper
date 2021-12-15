import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_helper/constants/constants.dart';

import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBg(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        color: CustomColors.almostBlack.withOpacity(0.8),
                        fontSize: UiConsts.largeFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      Colors.indigo.withOpacity(0.1),
                    ),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                onPressed: () {
                  final loginForm =
                      Provider.of<LoginFormProvider>(context, listen: false);
                  loginForm.reset();
                  Navigator.pushReplacementNamed(context, Routes.SIGNUP);
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: CustomColors.primary,
                      fontSize: UiConsts.smallFontSize),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    //TODO: setup the request
    onTap() async {
      FocusScope.of(context).unfocus();
      final authService = Provider.of<FBAuthService>(context, listen: false);

      if (!loginForm.isValidForm()) return;

      loginForm.isLoading = true;

      await authService.login(loginForm.email, loginForm.password);

      if (authService.user['email'] != '') {
        Navigator.pushReplacementNamed(context, Routes.TEACHER_HOME);
        loginForm.reset();
      } else {
        //NotificationsService.showSnackBar(
        //    message: 'Credenciales incorrectas', success: false);
        //
        print(authService.error);
      }
      loginForm.isLoading = false;
    }

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'johndoe@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_outlined),
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'This does not look like an email';
            },
            onChanged: (value) => loginForm.email = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.generalInputDecoration(
                hintText: '******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline),
            validator: (value) {
              if (value != null && value.length >= 6) return null;

              return 'Password should have more than 6 characters';
            },
            onChanged: (value) => loginForm.password = value,
          ),
          const SizedBox(
            height: 45,
          ),
          RequestButton(
              waitTitle: 'Please Wait',
              title: 'Sign In',
              isLoading: loginForm.isLoading,
              onTap: loginForm.isLoading ? null : () => onTap()),
        ],
      ),
    );
  }
}
