import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view/pages/signup.dart';
import 'package:music/features/authentication/view/widgets/widget.dart';
import 'package:music/features/authentication/view%20model/cubit/auth_cubit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSignInFailure) {
                showMessage(context, state.message);
              }
              if (state is AuthSignInSucsess) {
                context
                    .read<UserCubit>()
                    .initialize(jsonEncode(state.userModel));
              }
            },
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomForm(
                    controller: email,
                    label: "Email",
                    type: TextInputType.emailAddress),
                const SizedBox(height: 20),
                CustomForm(
                    controller: password, label: "Password", password: true),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    BlocProvider.of<AuthCubit>(context).signin(
                      email: email.text.trim(),
                      password: password.text.trim(),
                    );
                  },
                  title: "Login",
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: "Don't have account ",
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context)
                                  .pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                return const Signup();
                              }), (_) => false),
                        text: "signup",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
