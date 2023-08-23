

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/models/auth_utility.dart';
import '../../utils/assets_utils.dart';
import '../../widgets/screen_background.dart';
import '../bottom_navigation_base_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }


  void navigateToLogin(){
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      final bool isLoggedIn = await AuthUtility.checkIfUserLoggedIn();

      Get.offAll(()=> isLoggedIn
          ? const BottomNavigationBaseScreen()
          : const LoginScreen());


    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ScreenBackground(
          child: Center(
            child: SvgPicture.asset(AssetsUtils.logoSVG,
              fit: BoxFit.scaleDown,),
          )
        ),
      ),
    );
  }
}
