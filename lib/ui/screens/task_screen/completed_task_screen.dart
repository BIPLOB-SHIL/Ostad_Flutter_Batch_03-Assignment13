import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/update_task_status_bottom_sheet.dart';

import '../../../data/models/network_response.dart';
import '../../../data/models/task_list_model.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';
import '../../utils/show_snackbar.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';
import '../state_manager/all_task_controller.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  final AllTaskController allTaskController = Get.put<AllTaskController>(AllTaskController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      allTaskController.getAllTask(Urls.completeTask);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileBanner(),
            GetBuilder<AllTaskController>(
              builder: (allTaskController) {
                return Expanded(
                  child: allTaskController.getProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: allTaskController.taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              backgroundColor: Colors.teal,
                              data: allTaskController.taskListModel.data![index],
                              onDeleteTap: () {
                                allTaskController.deleteTask(allTaskController.taskListModel.data![index].sId!);
                              },
                              onEditTap: () {
                                showStatusTaskBottomSheet(allTaskController.taskListModel.data![index]);
                              },
                            );
                          },
                        ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
  void showStatusTaskBottomSheet(TaskData task) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        // isScrollControlled: true,
        builder: (context) {
          return UpdateStatusBottomSheet(
              task: task,
              onUpdate: () {
                allTaskController.getAllTask(Urls.completeTask);
              });
        });
  }
}
