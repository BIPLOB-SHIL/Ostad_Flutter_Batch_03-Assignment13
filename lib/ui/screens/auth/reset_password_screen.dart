import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../utils/getx_snackbar.dart';
import '../../widgets/screen_background.dart';
import '../state_manager/reset_password_controller.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email, otp;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {


  final _passWordFormKey = GlobalKey<FormState>();

  final ResetPasswordController resetPasswordController = Get.put(ResetPasswordController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _passWordFormKey,
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
                      controller: resetPasswordController.passwordController,
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
                      controller: resetPasswordController.confirmPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Confirm password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }else if (value != resetPasswordController.passwordController.text){
                          return 'Confirm password doesn\'t match';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<ResetPasswordController>(
                      builder: (resetPasswordController) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_passWordFormKey.currentState!.validate()) {
                              resetPasswordController.resetPassword(widget.email,widget.otp).then((value){

                                if(value == true){
                                  showGetXSnackBar("Reset password","Password reset successful",Colors.green[500], true);
                                  Get.offAll(()=> const LoginScreen());
                                }
                                else{
                                  showGetXSnackBar("Reset password","Reset password failed",Colors.red[500], false);
                                }

                              });
                            }
                          },
                          child: const Text("Confirm"),
                        );
                      }
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
                          Get.offAll(()=>const LoginScreen());
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
