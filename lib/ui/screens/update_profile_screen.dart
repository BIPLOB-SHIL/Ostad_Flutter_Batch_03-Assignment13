import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_getx/ui/screens/state_manager/update_profile_controller.dart';
import '../../data/models/auth_utility.dart';
import '../../data/models/login_model.dart';
import '../utils/getx_snackbar.dart';
import '../widgets/screen_background.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserData userData = AuthUtility.userInfo.data!;

  bool _isVisible = true;
  final _updateProfileFormKey = GlobalKey<FormState>();

  final ImagePicker imagePicker = ImagePicker();
  String? base64String;
  XFile? imageFile;
  String? imagePath = '';

  final UpdateProfileController updateProfileController =
      Get.put<UpdateProfileController>(UpdateProfileController());

  @override
  void initState() {
    super.initState();
    updateProfileController.emailController.text = userData.email ?? "";
    updateProfileController.firstNameController.text = userData.firstName ?? "";
    updateProfileController.lastNameController.text = userData.lastName ?? "";
    updateProfileController.mobileController.text = userData.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _updateProfileFormKey,
      child: ScreenBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text("Update Profile",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: 16,
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: imagePath!.isNotEmpty
                              ? FileImage(File(imagePath.toString()))
                              : null),
                      Positioned(
                        bottom: -10,
                        left: 50,
                        child: IconButton(
                          onPressed: () {
                            getImage();
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //  SizedBox(
                  //   height: 100,
                  //   child: CircleAvatar(
                  //     radius: 50,
                  //     backgroundImage: imagePath.isNotEmpty ?
                  //     FileImage(File(imagePath.toString())) :
                  //         null
                  //   ),
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         flex: 3,
                  //         child: SizedBox(
                  //           height: 50,
                  //           child: TextButton(
                  //             onPressed: ()  {
                  //               getImage();
                  //             },
                  //             style: ElevatedButton.styleFrom(
                  //               backgroundColor:
                  //                   Colors.grey, // This is what you need!
                  //             ),
                  //             child: const Text(
                  //               "Photos",
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //           ),
                  //         )),
                  //     //  Expanded(
                  //     //   flex: 7,
                  //     //   child: Container(
                  //     //      width: double.infinity,
                  //     //     height: 50,
                  //     //     alignment: Alignment.centerLeft,
                  //     //     decoration: const BoxDecoration(
                  //     //       color: Colors.white
                  //     //     ),
                  //     //     child: Padding(
                  //     //       padding: const EdgeInsets.all(8.0),
                  //     //       child: Text(""),
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: updateProfileController.emailController,
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: updateProfileController.firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: updateProfileController.lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                      controller: updateProfileController.mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Mobile",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required field is empty';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: updateProfileController.passwordController,
                    keyboardType: TextInputType.phone,
                    obscureText: _isVisible,
                    decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (mounted) {
                              _isVisible = !_isVisible;
                              setState(() {});
                            }
                          },
                          icon: _isVisible
                              ? const Icon(Icons.visibility_off)
                              : const Icon(
                                  Icons.visibility,
                                ),
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GetBuilder<UpdateProfileController>(
                      builder: (updateProfileController) {
                    return SizedBox(
                      width: double.infinity,
                      child: updateProfileController.profileUpdateInProgress
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                if (_updateProfileFormKey.currentState!
                                    .validate()) {
                                  updateProfileController
                                      .updateProfile()
                                      .then((value) {
                                    if (value == true) {
                                      userData.firstName =
                                          updateProfileController
                                              .firstNameController.text
                                              .trim();
                                      userData.lastName =
                                          updateProfileController
                                              .lastNameController.text
                                              .trim();
                                      userData.mobile = updateProfileController
                                          .mobileController.text
                                          .trim();
                                      AuthUtility.updateUserInfo(userData);
                                      showGetXSnackBar(
                                          "Profile update",
                                          "Profile updated",
                                          Colors.green[500],
                                          true);
                                    } else {
                                      showSnackBar(
                                          "Profile update",
                                          "Profile update failed, try again",
                                          Colors.red[500],
                                          false);
                                    }
                                  });
                                }
                              },
                              child: const Icon(
                                  Icons.arrow_circle_right_outlined)),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void getImage() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imagePath = pickedImage.path.toString();
    }
  }
}
