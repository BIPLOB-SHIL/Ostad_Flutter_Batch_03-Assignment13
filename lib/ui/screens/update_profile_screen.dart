import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/auth_utility.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/screen_background.dart';


class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserData userData = AuthUtility.userInfo.data!;

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _profileUpdateInProgress = false;

  bool _isVisible = true;
  final _formKey = GlobalKey<FormState>();

  XFile? imageFile;
  ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _emailController.text = userData.email ?? "";
    _firstNameController.text = userData.firstName ?? "";
    _lastNameController.text = userData.lastName ?? "";
    _mobileController.text = userData.mobile ?? "";
  }

  Future<void> updateProfile() async {
    _profileUpdateInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final Map<String, dynamic> responseBody = {
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "photo": ""
    };

    if (_passwordController.text.isNotEmpty) {
      responseBody["password"] = _passwordController.text;
    }

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.profileUpdate, responseBody);

    _profileUpdateInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
       userData.firstName = _firstNameController.text.trim();
       userData.lastName = _lastNameController.text.trim();
       userData.mobile = _mobileController.text.trim();

       AuthUtility.updateUserInfo(userData);

      _passwordController.clear();
      if (mounted) {
        showSnackBar("Profile updated", context, Colors.green[500], true);
      }
    } else {
      if (mounted) {
        showSnackBar("Profile update failed, try again", context,
            Colors.red[500], false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
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
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey, // This is what you need!
                              ),
                              child: const Text(
                                "Photos",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                      const Expanded(
                        flex: 7,
                        child: TextField(
                          decoration: InputDecoration(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: _emailController,
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
                      controller: _firstNameController,
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
                      controller: _lastNameController,
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
                      controller: _mobileController,
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
                    controller: _passwordController,
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
                  SizedBox(
                    width: double.infinity,
                    child: _profileUpdateInProgress
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateProfile();
                              }
                            },
                            child:
                                const Icon(Icons.arrow_circle_right_outlined)),
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
