import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auth_utility.dart';
import '../../../data/models/login_model.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class SignUpController extends GetxController {

  final  _emailAddressController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final  _passwordController = TextEditingController();

  get emailAddressController => _emailAddressController;
  get firstNameController => _firstNameController;
  get lastNameController => _lastNameController;
  get mobileController => _mobileController;
  get passwordController => _passwordController;


  bool _signUpInProgress = false;
  get signUpInProgress => _signUpInProgress;


  Future<bool> userSignUp() async {
    _signUpInProgress = true;
    update();

    Map<String, dynamic> responseBody = <String, dynamic>{
      "email": _emailAddressController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "password": _passwordController.text,
      "photo": ""
    };

    final response =
    await NetworkCaller().postRequest(Urls.registrationUrl, responseBody);

    _signUpInProgress = false;
    update();

    if (response.isSuccess) {

      _emailAddressController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _mobileController.clear();
      _passwordController.clear();

      return true;

    } else {
      return false;

    }
  }

  }




