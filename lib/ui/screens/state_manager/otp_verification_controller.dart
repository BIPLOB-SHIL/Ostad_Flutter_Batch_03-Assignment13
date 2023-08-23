import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class OtpVerificationController extends GetxController {

  final _otpEditingController = TextEditingController();
  get otpEditingController => _otpEditingController;



  bool _otpVerificationInProgress = false;
  get otpVerificationInProgress => _otpVerificationInProgress;


  Future<bool> verifyOtp(String email) async {
    _otpVerificationInProgress = true;
    update();
    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.otpVerify(email, _otpEditingController.text));

    _otpVerificationInProgress = false;
   update();
    if (response.body!['status'] == 'success') {
      return true;

    } else {
      return false;

    }
  }

  }




