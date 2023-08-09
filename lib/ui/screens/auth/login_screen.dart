import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/bottom_navigation_base_screen.dart';
import 'package:task_manager/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/signup_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../utils/show_snackbar.dart';


class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailAddressController = TextEditingController();
  final  _passwordController = TextEditingController();

  bool _isVisible = true;
  bool _logInProgress = false;

  final _formKey = GlobalKey<FormState>();


  bool validateEmail(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
  }

  Future<void> userLogIn() async{

    _logInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String,dynamic> responseBody = {
      "email":_emailAddressController.text.trim(),
      "password":_passwordController.text
    };

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.loginUrl, responseBody);

    _logInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);

      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (
                context) => const BottomNavigationBaseScreen()), (
                route) => false);
      }
    } else {
      if (mounted) {
        showSnackBar("Incorrect email or password", context, Colors.red[500], false);
      }
    }

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
                      controller: _emailAddressController,
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
                      controller: _passwordController,
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
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _logInProgress == false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              userLogIn();
                            }
                          },
                          child: const Icon(Icons.arrow_forward_ios),

                  ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmailVerificationScreen(),
                          ),
                        );
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
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



