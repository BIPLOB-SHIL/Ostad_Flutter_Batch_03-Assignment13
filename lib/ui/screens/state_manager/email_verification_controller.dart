import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class EmailVerificationController extends GetxController {

  final _emailAddressController = TextEditingController();
  get emailAddressController => _emailAddressController;



  bool _emailVerificationInProgress = false;
  get emailVerificationInProgress => _emailVerificationInProgress;


  Future<bool> sendOTPToEmail() async {
    _emailVerificationInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.sendOtpToEmail(_emailAddressController.text.trim()));

    _emailVerificationInProgress = false;
    update();

    if (response.isSuccess) {
      return true;

    } else {
      return false;
    }
  }

  }




