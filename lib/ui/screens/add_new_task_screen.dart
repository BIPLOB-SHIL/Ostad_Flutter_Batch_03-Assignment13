import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/screen_background.dart';
import '../widgets/user_profile_banner.dart';

class AddNewTaskScreen extends StatefulWidget {
   const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

   final _titleController = TextEditingController();
   final _descriptionController = TextEditingController();

   bool _addNewTaskInProgress = false;
   final _formKey = GlobalKey<FormState>();

   Future<void> addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> responseBody = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTaskUrl, responseBody);

    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      _titleController.clear();
      _descriptionController.clear();
      if (mounted) {
        showSnackBar(
            "Task added successfully", context, Colors.green[500], true);
      } else {
        if (mounted) {
          showSnackBar("Task add failed", context, Colors.red[500], true);
        }
      }
    }
  }

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
                  key: _formKey,
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
                          controller: _titleController,
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
                          controller: _descriptionController,
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
                        SizedBox(
                          width: double.infinity,
                          child: Visibility(
                            visible: _addNewTaskInProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  addNewTask();
                                }
                              },
                              child:
                                  const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          ),
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
