import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/providers/providers.dart';
import 'package:t_helper/routes/routes.dart';
import 'package:t_helper/services/services.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class AuthLayout extends StatelessWidget {
  final bool login;

  const AuthLayout({Key? key, required this.login}) : super(key: key);

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
                      login ? 'Login' : 'Sign Up',
                      style: TextStyle(
                        color: CustomColors.almostBlack.withOpacity(0.8),
                        fontSize: UiConsts.largeFontSize,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ChangeNotifierProvider(
                      create: (_) => AuthFormProvider(),
                      child: _AuthForm(
                        login: login,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      CustomColors.primary.withOpacity(0.1),
                    ),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                onPressed: () {
                  final authForm =
                      Provider.of<AuthFormProvider>(context, listen: false);
                  authForm.reset();
                  Navigator.pushReplacementNamed(
                      context, login ? Routes.SIGNUP : Routes.LOGIN);
                },
                child: Text(
                  login ? 'Sign Up?' : 'Log In?',
                  style: const TextStyle(
                      color: CustomColors.primary,
                      fontSize: UiConsts.smallFontSize),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final bool login;

  const _AuthForm({Key? key, required this.login}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authForm = Provider.of<AuthFormProvider>(context);

    onTap() async {
      FocusScope.of(context).unfocus();
      final authService = Provider.of<FBAuthService>(context, listen: false);

      if (!authForm.isValidForm()) return;

      authForm.isLoading = true;

      if (login) {
        await authService.login(authForm.email, authForm.password);
      } else {
        await authService.signup(authForm.email, authForm.password);
      }

      if (authService.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
            snackbar(message: authService.error!, success: false));
        authForm.isLoading = false;
      } else {
        authForm.reset();
        if (login) {
          Navigator.pushReplacementNamed(context, Routes.HOME);
        }
      }
    }

    return Form(
      key: authForm.formKey,
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
            onChanged: (value) => authForm.email = value,
          ),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.generalInputDecoration(
                hintText: '******',
                labelText: 'Password',
                prefixIcon: Icons.lock_outline),
            validator: (value) {
              if (value != null && value.length >= 6) return null;

              return 'Password should have more than 6 characters';
            },
            onChanged: (value) => authForm.password = value,
          ),
          SizedBox(
            height: login ? 0 : 30,
          ),
          login
              ? const SizedBox(
                  height: 0,
                )
              : TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecorations.generalInputDecoration(
                      hintText: '******',
                      labelText: 'Confirm Password',
                      prefixIcon: Icons.lock_outline),
                  validator: (value) {
                    if (value == authForm.password) return null;

                    return 'Password fields must match';
                  },
                  onChanged: (value) => authForm.confirmPassword = value,
                ),
          const SizedBox(
            height: 45,
          ),
          RequestButton(
              waitTitle: 'Please Wait',
              title: login ? 'Sign In' : 'Register',
              isLoading: authForm.isLoading,
              onTap: authForm.isLoading ? null : () => onTap()),
        ],
      ),
    );
  }
}
