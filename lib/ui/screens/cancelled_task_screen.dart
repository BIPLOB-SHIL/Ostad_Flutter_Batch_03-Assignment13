import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_getx/ui/screens/update_task_status_bottom_sheet.dart';


import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/screen_background.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  bool _getCancelledTaskInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCancelledTask();
    });
  }

  Future<void> getCancelledTask() async{
    _getCancelledTaskInProgress  = true;
    if(mounted){
      setState(() {
      });
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.cancelledTask);
    if(response.isSuccess){
      _taskListModel = TaskListModel.fromJson(response.body!);

    }else {
      if(mounted){
        showSnackBar("Cancelled task failed", context, Colors.red[500], false);
      }
    }
    _getCancelledTaskInProgress  = false;
    if(mounted){
      setState(() {
      });
    }


  }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if (mounted) {
        setState(() {});
        showSnackBar(
            "Task successfully deleted", context, Colors.green[500], true);
      }
    } else {
      if (mounted) {
        showSnackBar("Deletion of the task has been failed", context,
            Colors.red[500], false);
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
              child: _getCancelledTaskInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: _taskListModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          backgroundColor: Colors.red,
                          data: _taskListModel.data![index],
                          onDeleteTap: () {
                            deleteTask(_taskListModel.data![index].sId!);
                          },
                          onEditTap: () {
                            showStatusTaskBottomSheet(_taskListModel.data![index]);
                          },
                        );
                      },
                    ),
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
                getCancelledTask();
              });
        });
  }
}
