import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/state_manager/email_verification_controller.dart';
import 'package:task_manager_getx/ui/screens/state_manager/new_task_controller.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/getx_snackbar.dart';
import '../widgets/screen_background.dart';
import '../widgets/user_profile_banner.dart';

class AddNewTaskScreen extends StatefulWidget {
   const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {


   final _newTaskFormKey = GlobalKey<FormState>();

   final NewTaskController newTaskController = Get.put<NewTaskController>(NewTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileBanner(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _newTaskFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text("Add New Task",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: newTaskController.titleController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Subject",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required field is empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: newTaskController.descriptionController,
                          keyboardType: TextInputType.text,
                          maxLines: 7,
                          decoration: const InputDecoration(
                            hintText: "Description",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required field is empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GetBuilder<NewTaskController>(
                          builder: (newTaskController) {
                            return SizedBox(
                              width: double.infinity,
                              child: Visibility(
                                visible: newTaskController.addNewTaskInProgress == false,
                                replacement: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_newTaskFormKey.currentState!.validate()) {
                                      newTaskController.addNewTask().then((value){
                                        if (value == true){
                                          showGetXSnackBar("Add new task","Task added successfully",Colors.green[500], true);
                                        }else {
                                          showGetXSnackBar("Add new task","Task add failed", Colors.red[500], true);
                                        }
                                      });
                                    }
                                  },
                                  child:
                                      const Icon(Icons.arrow_circle_right_outlined),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
