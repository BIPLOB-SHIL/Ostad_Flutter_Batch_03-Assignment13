import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/screen_background.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final _emailAddressController = TextEditingController();
  final  _passwordController = TextEditingController();

  bool _isVisible = true;

  final _formKey = GlobalKey<FormState>();


  bool validateEmail(String email) {
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;
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
                      const SizedBox(height: 16,),
                      Row(
                        children: [
                           Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 50,
                              child: TextButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey, // This is what you need!
                                ),
                                child: const Text("Photos",style: TextStyle(color: Colors.white),),
                              ),
                            )
                            ),


                            Expanded(
                              flex: 7,
                             child: TextField(
                              decoration: InputDecoration(
                              ),
                          ),
                           ),

                        ],
                      ),
                      const SizedBox(height: 12,),
                      TextFormField(
                          controller: _emailAddressController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email",
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty)
                            {
                              return 'Required field is empty';
                            }

                            if(validateEmail(value)== false){
                              return 'Invalid email';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 12,),
                      TextFormField(
                          controller: _emailAddressController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "First Name",
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty)
                            {
                              return 'Required field is empty';
                            }

                            if(validateEmail(value)== false){
                              return 'Invalid email';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 12,),
                      TextFormField(
                          controller: _emailAddressController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Last Name",
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty)
                            {
                              return 'Required field is empty';
                            }

                            if(validateEmail(value)== false){
                              return 'Invalid email';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 12,),
                      TextFormField(
                          controller: _emailAddressController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: "Mobile",
                          ),
                          validator: (value){
                            if(value == null || value.isEmpty)
                            {
                              return 'Required field is empty';
                            }

                            if(validateEmail(value)== false){
                              return 'Invalid email';
                            }
                            return null;
                          }
                      ),
                      const SizedBox(height: 12,),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.phone,
                        obscureText: _isVisible,
                        decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              onPressed: (){
                                if(mounted) {
                                  _isVisible = !_isVisible;
                                  setState(() {
                                  });
                                }
                              },
                              icon: _isVisible ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility,),
                            )
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required field is empty';
                          }
                          if (value.length < 8) {
                            return 'The password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()){

                              }
                            },
                            child: const Icon(Icons.arrow_circle_right_outlined)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )

    );
  }
}
