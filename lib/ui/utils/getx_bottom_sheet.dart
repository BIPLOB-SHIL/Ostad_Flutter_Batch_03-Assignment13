import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/models/task_list_model.dart';
import '../screens/state_manager/all_task_controller.dart';
import '../screens/update_task_status_bottom_sheet.dart';

showGetXStatusTaskBottomSheet(TaskData task,bottomUrl) {
  final AllTaskController allTaskController = Get.put<AllTaskController>(AllTaskController());

    Get.bottomSheet(
      Card(
        elevation: 5,
        child: Container(
          height: 350,
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpdateStatusBottomSheet(
                task: task,
                onUpdate: () {
                  allTaskController.getAllTask(bottomUrl);
                },
              )),
        ),
      ),
      enableDrag: false,
      isDismissible: false,
      // barrierColor: Colors.indigo[200],
    );
  }

