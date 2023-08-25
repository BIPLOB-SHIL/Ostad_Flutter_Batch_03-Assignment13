

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/models/auth_utility.dart';
import '../screens/auth/login_screen.dart';
import '../screens/update_profile_screen.dart';

class UserProfileBanner extends StatefulWidget {
  const UserProfileBanner({
    super.key,
  });

  @override
  State<UserProfileBanner> createState() => _UserProfileBannerState();
}

class _UserProfileBannerState extends State<UserProfileBanner> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        onTap: () {
          Get.to(()=> const UpdateProfileScreen());
        },
        tileColor: Colors.white,
        leading: const CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 24,
          backgroundImage: NetworkImage(
              "https://media.licdn.com/dms/image/D5603AQGwbHLG5Eobdg/profile-displayphoto-shrink_200_200/0/1681552491981?e=1695254400&v=beta&t=MFD8fJW_yzn08r-q9rWYRZ27M2St40t4knESj9uDMWU"),
        ),
        title:  Text(
          "${AuthUtility.userInfo.data?.firstName ?? ''} ${AuthUtility.userInfo.data?.lastName ?? ''}",
          style: const TextStyle(color: Colors.black),
        ),
        subtitle:  Text(
          AuthUtility.userInfo.data?.email ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        trailing: IconButton(
          onPressed: () async {
            await AuthUtility.clearUserInfo();
            if(mounted) {
              Get.offAll(() => const LoginScreen());
            }
          },
          icon: const Icon(Icons.logout, color: Colors.black,),
        ),
      ),
    );
  }
}
