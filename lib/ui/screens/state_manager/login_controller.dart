import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class LoginController extends GetxController {

  final _emailAddressController = TextEditingController();
  final _passwordController = TextEditingController();

  get emailAddressController => _emailAddressController;
  get passwordController => _passwordController;

  bool _logInProgress = false;
  get logInProgress => _logInProgress;


  Future<bool> userLogIn() async{

    _logInProgress = true;
    update();

    Map<String,dynamic> responseBody = {
      "email": _emailAddressController.text.trim(),
      "password": _passwordController.text
    };

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.loginUrl, responseBody,isLogin: true);


    _logInProgress = false;
    update();

    if (response.isSuccess) {
      await AuthUtility.saveUserInfo(LoginModel.fromJson(response.body!));
       return true;

      } else {
        return false;
    }


    }

  }




