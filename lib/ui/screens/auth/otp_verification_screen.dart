import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_getx/ui/screens/auth/reset_password_screen.dart';
import '../../utils/getx_snackbar.dart';
import '../../widgets/screen_background.dart';
import '../state_manager/otp_verification_controller.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {


  final OtpVerificationController otpVerificationController = Get.put(OtpVerificationController());

  final _otpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _otpFormKey,
          child: ScreenBackground(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PIN Verification",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(
                        height: 4,
                      ),
                      Text("A 6 digits pin will sent to your email address",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(
                        height: 16,
                      ),
                      PinCodeTextField(
                        backgroundColor: const Color(0xFFF3F5F3),
                        length: 6,
                        obscureText: false,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.number,
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            inactiveFillColor: const Color(0xFFF3F5F3),
                            inactiveColor: const Color(0x3700FF83),
                            activeColor: const Color(0x3700FF83),
                            selectedColor: const Color(0xFF00FF83),
                            selectedFillColor: const Color(0xFFF3F5F3),
                            activeFillColor: const Color(0xFFF3F5F3),
                        ),
                        animationDuration: const Duration(milliseconds: 300),
                        enableActiveFill: true,
                        cursorColor: Colors.teal,
                        enablePinAutofill: true,
                        controller: otpVerificationController.otpEditingController,
                        onCompleted: (v) {

                        },
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null;
                            }
                            return null;
                          },
                        onChanged: (value) {

                        },
                        beforeTextPaste: (text) {
                         // print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                        appContext: context,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      GetBuilder<OtpVerificationController>(
                        builder: (otpVerificationController) {
                          return SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: otpVerificationController.otpVerificationInProgress == false,
                              replacement: const Center(child: CircularProgressIndicator(),),
                              child: ElevatedButton(
                                onPressed: () {
                              if (_otpFormKey.currentState!.validate()) {

                                    otpVerificationController.verifyOtp(widget.email).then((value){

                                      if(value == true){
                                        Get.to(()=> ResetPasswordScreen(email: widget.email,otp: otpVerificationController.otpEditingController.text,));
                                      }
                                      else{
                                        showGetXSnackBar("OTP verification","OTP verification failed", Colors.red[500], false);
                                      }

                                    });
                                }
                                },
                                child: const Text(
                                  "Verify",
                                ),
                              ),
                            ),
                          );
                        }
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
                              Get.offAll(() => const LoginScreen());
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
