import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/auth/signup_screen.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';
import '../../utils/show_snackbar.dart';
import '../../widgets/screen_background.dart';
import '../bottom_navigation_base_screen.dart';
import '../state_manager/login_controller.dart';
import 'email_verification_screen.dart';

class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isVisible = true;
  final _formKey = GlobalKey<FormState>();


 // final LoginController loginController = Get.put<LoginController>(LoginController());
  final LoginController loginController = Get.put(LoginController());

  bool validateEmail(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Get Started With",
                    style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16,),
                    TextFormField(
                      controller: loginController.emailAddressController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                        validator: (value){
                          if(value == null || value.isEmpty)
                          {
                            return 'Required field is empty';
                          }
                          if(validateEmail(value)== false){
                            return 'Invalid email';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 12,),
                    TextFormField(
                      controller: loginController.passwordController,
                      keyboardType: TextInputType.phone,
                      obscureText: _isVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: (){
                            if(mounted) {
                              _isVisible = !_isVisible;
                              setState(() {
                              });
                            }
                          },
                          icon: _isVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility,),
                        )
                      ),
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
                  GetBuilder<LoginController>(
                    builder: (longinController) {
                      return SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: loginController.logInProgress == false,
                          replacement: const Center(child: CircularProgressIndicator(),),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  loginController.userLogIn().then((value){
                                    if(value == true){
                                      Get.off(()=> const BottomNavigationBaseScreen());
                                    }
                                    else{
                                      showSnackBar("Incorrect email or password", context, Colors.red[500], false);
                                    }

                                  });
                                }
                              },
                              child: const Icon(Icons.arrow_forward_ios),

                      ),
                        ),
                      );
                    }
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.to(()=>const EmailVerificationScreen());
                      },
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, letterSpacing: 0.5),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(()=>const SignUpScreen());
                        },
                        child: const Text("Sign up"),
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



