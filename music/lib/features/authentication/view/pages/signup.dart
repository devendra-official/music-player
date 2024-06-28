import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/core/utils/utils.dart';
import 'package:music/features/authentication/view/pages/login.dart';
import 'package:music/features/authentication/view/widgets/widget.dart';
import 'package:music/features/authentication/viewmodel/cubit/auth_cubit.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
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
              if (state is AuthSignUpFailure) {
                showMessage(context, state.message);
              }
              if (state is AuthSignUpSucsess) {
                showMessage(context, state.message);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const Login();
                }), (_) => false);
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomForm(
                    controller: name,
                    label: "Name",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomForm(
                    controller: email,
                    label: "Email",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomForm(
                    controller: password,
                    label: "Password",
                    password: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!RegExp(r'.{8,}').hasMatch(value)) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must include at least one uppercase letter';
                      }
                      if (!RegExp(r'[a-z]').hasMatch(value)) {
                        return 'Password must include at least one lowercase letter';
                      }
                      if (!RegExp(r'\d').hasMatch(value)) {
                        return 'Password must include at least one number';
                      }
                      if (!RegExp(r'[\W_]').hasMatch(value)) {
                        return 'Password must include at least one special character';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        BlocProvider.of<AuthCubit>(context).signup(
                          name: name.text,
                          email: email.text,
                          password: password.text,
                        );
                      }
                    },
                    title: "SignUp",
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "Already have account ",
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context)
                                    .pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                  return const Login();
                                }), (_) => false),
                          text: "signin",
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
      ),
    );
  }
}
