import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:t_helper/constants/constants.dart';
import 'package:t_helper/controllers/controllers.dart';
import 'package:t_helper/controllers/login_form_controller.dart';
import 'package:t_helper/functions/login.dart';
import 'package:t_helper/screens/signup_screen.dart';
import 'package:t_helper/utils/utils.dart';
import 'package:t_helper/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormController = Get.put(LoginFormController());

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
                    _LoginForm(),
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
                  Get.off(() => const SignupScreen());
                  loginFormController.reset();
                },
                child: const Text(
                  'Sign Up?',
                  style: TextStyle(
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

class _LoginForm extends StatelessWidget {
  _LoginForm({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    LoginFormController loginFormController = Get.find();

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.generalInputDecoration(
                hintText: 'johndoe@email.com',
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
            onChanged: (value) => loginFormController.email = value,
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
              if (value != null && value.length >= 7) return null;

              return 'Password should have more than 6 characters';
            },
            onChanged: (value) => loginFormController.password = value,
          ),
          const SizedBox(
            height: 45,
          ),
          Obx(
            () => RequestButton(
                waitTitle: 'Please Wait',
                title: 'Sign In',
                isLoading: loginFormController.isLoading.value,
                onTap: loginFormController.isLoading.value
                    ? null
                    : () => loginOnTap(context, formKey)),
          )
        ],
      ),
    );
  }
}
