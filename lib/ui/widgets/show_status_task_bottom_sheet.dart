import 'package:flutter/material.dart';

import '../../data/models/task_list_model.dart';
import '../screens/update_task_status_bottom_sheet.dart';

void showStatusTaskBottomSheet(TaskData task, BuildContext context,) {
  showModalBottomSheet(
      context: context,
      useSafeArea: true,
      // isScrollControlled: true,
      builder: (context) {
        return UpdateStatusBottomSheet(
            task: task,
            onUpdate: () {
           //   getNewTask();
            });
      });
}