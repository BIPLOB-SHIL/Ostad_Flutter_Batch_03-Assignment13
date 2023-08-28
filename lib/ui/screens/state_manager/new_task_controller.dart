import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class NewTaskController extends GetxController {
  final _titleController = TextEditingController();
  get titleController => _titleController;
  final _descriptionController = TextEditingController();
  get descriptionController => _descriptionController;

  bool _addNewTaskInProgress = false;

  bool get addNewTaskInProgress => _addNewTaskInProgress;

  Future<bool> addNewTask() async {
    _addNewTaskInProgress = true;
    update();

    Map<String, dynamic> responseBody = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTaskUrl, responseBody);

    _addNewTaskInProgress = false;
    update();

    if (response.isSuccess) {
      _titleController.clear();
      _descriptionController.clear();
      update();
      return true;
    } else {
      return false;
    }
  }
}
