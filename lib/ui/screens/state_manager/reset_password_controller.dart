import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class ResetPasswordController extends GetxController {

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  get passwordController => _passwordController;
  get confirmPasswordController => _confirmPasswordController;


  bool _setPasswordInProgress = false;
  get setPasswordInProgress => _setPasswordInProgress;


  Future<bool> resetPassword(String email,String otp) async {
    _setPasswordInProgress = true;
    update();

    final Map<String,dynamic> responseBody = {
      "email": email,
      "OTP":  otp,
      "password": _passwordController.text

    };
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.resetPassword,responseBody);

    _setPasswordInProgress = false;
    update();
    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

  }




