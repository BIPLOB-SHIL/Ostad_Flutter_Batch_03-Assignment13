import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';
import '../../utils/show_snackbar.dart';
import '../../widgets/screen_background.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email, otp;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _setPasswordInProgress = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    _setPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final Map<String,dynamic> responseBody = {
        "email":widget.email,
        "OTP": widget.otp,
        "password": _passwordController.text

    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.resetPassword,responseBody);

    _setPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
         showSnackBar("Password reset successful", context, Colors.green[500], true);
         Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        showSnackBar("Reset password failed", context, Colors.red[500], false);
      }
    }
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
                  Text(
                      "Minimum password should be 8 letters with numbers & symbols",
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        if (value.length < 8) {
                          return 'The password must be at least 8 characters long';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Confirm password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }else if (value != _passwordController.text){
                          return 'Confirm password doesn\'t match';
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
                        if (_formKey.currentState!.validate()) {
                          resetPassword();
                        }
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
    ));
  }
}
