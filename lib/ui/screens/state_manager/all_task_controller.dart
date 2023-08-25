import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/network_response.dart';
import '../../../data/models/task_list_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';
import '../../utils/show_snackbar.dart';


class AllTaskController extends GetxController {
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get taskListModel => _taskListModel;


  bool _getProgress = false;
  bool get getProgress => _getProgress;


  Future<bool> deleteTask(String taskId) async {
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      update();
      showGetXSnackBar(
          "Delete", "Task successfully deleted", Colors.green[500], true);
      return true;
    } else {
      update();
      showGetXSnackBar("Delete", "Deletion of the task has been failed",
          Colors.red[500], false);
      return false;
    }
  }


  Future<bool> getAllTask(String bottomTaskUrl) async {
    _getProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller().getRequest(bottomTaskUrl);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
      _getProgress = false;
      update();
      return true;
    } else {
      update();
      showGetXSnackBar(
          "Task Status", "Task failed", Colors.red[500], false);
      return false;
    }
  }


}
