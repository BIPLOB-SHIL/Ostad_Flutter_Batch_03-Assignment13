import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import 'login_screen.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email,otp;
  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailAddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool validateEmail(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ScreenBackground(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Set Password",
                      style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 4,
                    ),
                  Text("Minimum password should be 8 letters with numbers & symbols",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: _emailAddressController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }

                        if (validateEmail(value) == false) {
                          return 'Invalid email';
                        }
                        return null;
                      }),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                        controller: _emailAddressController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Confirm password",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required field is empty';
                          }

                          if (validateEmail(value) == false) {
                            return 'Invalid email';
                          }
                          return null;
                        }),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                         // if (_formKey.currentState!.validate()) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                                  (route) => false);
                         // }
                        },
                        child: const Text("Confirm"),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, letterSpacing: 0.5),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                    (route) => false);
                          },
                          child: const Text("Sign in"),
                        ),
                      ],
                    ),
                ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
