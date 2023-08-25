import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/auth/login_screen.dart';
import 'package:task_manager_getx/ui/screens/state_manager/signup_controller.dart';
import '../../utils/show_snackbar.dart';
import '../../widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool _isPasswordVisible = true;
  final _signUpFormKey = GlobalKey<FormState>();

  final SignUpController signUpController = Get.put<SignUpController>(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Join With Us",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: signUpController.emailAddressController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "Please enter valid email";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: signUpController.firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: signUpController.lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: signUpController.mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Mobile",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        if (value.length != 11) {
                          return "Mobile Number must be of 11 digit";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: signUpController.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isPasswordVisible,
                    decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (mounted) {
                              _isPasswordVisible = !_isPasswordVisible;
                              setState(() {});
                            }
                          },
                          icon: _isPasswordVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(
                                  Icons.visibility,
                                ),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required field is empty';
                      }
                      if (value.length < 8) {
                        return 'The password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<SignUpController>(builder: (signUpController) {
                    return SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: signUpController.signUpInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                            onPressed: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                signUpController.userSignUp().then((value) {
                                  if (value == true) {
                                    showGetXSnackBar("Sign up","Registration successful", Colors.green[500], true);
                                    Get.off(() => const LoginScreen());
                                  } else {
                                    showGetXSnackBar("Sign up","Registration failed",Colors.red[500], false);
                                  }
                                });
                              }
                            },
                            child:
                                const Icon(Icons.arrow_circle_right_outlined)),
                      ),
                    );
                  }),
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
                          Get.back();
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
