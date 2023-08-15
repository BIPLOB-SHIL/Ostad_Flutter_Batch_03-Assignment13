import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/summary_count_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/screens/update_task_bottom_sheet.dart';
import 'package:task_manager/ui/screens/update_task_status_bottom_sheet.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  bool _getCountSummaryInProgress = false;
  bool _getNewTaskInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  TaskListModel _taskListModel = TaskListModel();





  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCountSummary();
      getNewTask();
    });
  }

  Future<void> getCountSummary() async{
    _getCountSummaryInProgress = true;
    if(mounted){
      setState(() {
      });
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.summaryCount);
    if(response.isSuccess){
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);

    }else {
      if(mounted){
        showSnackBar("Get summary count failed", context, Colors.red[500], false);
      }
    }
    _getCountSummaryInProgress = false;
    if(mounted){
      setState(() {
      });
    }


  }

  Future<void> getNewTask() async{
    _getNewTaskInProgress = true;
    if(mounted){
      setState(() {
      });
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.newTask);
    if(response.isSuccess){
      _taskListModel = TaskListModel.fromJson(response.body!);

    }else {
      if(mounted){
        showSnackBar("Get new task failed", context, Colors.red[500], false);
      }
    }
    _getNewTaskInProgress = false;
    if(mounted){
      setState(() {
      });
    }


}

  Future<void> deleteTask(String taskId) async{

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if(response.isSuccess){
      _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if(mounted){
        setState(() {

        });
        showSnackBar("Task successfully deleted", context, Colors.green[500], true);
      }

    }else {
      if(mounted){
        showSnackBar("Deletion of the task has been failed", context, Colors.red[500], false);
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getCountSummaryInProgress
                  ? const LinearProgressIndicator()
                  : Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            number: 1235,
                            title: "New",
                          ),
                        ),
                        Expanded(
                          child: SummaryCard(
                            number: 1235,
                            title: "Progress",
                          ),
                        ),
                        Expanded(
                          child: SummaryCard(
                            number: 1523,
                            title: "Canceled",
                          ),
                        ),
                        Expanded(
                          child: SummaryCard(
                            number: 1263,
                            title: "Completed",
                          ),
                        )
                      ],
                    ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNewTask();
                },
                child: _getNewTaskInProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: _taskListModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            backgroundColor: Colors.blue,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return UpdateTaskBottomSheet(
            task: task,
            onUpdate: () {
              getNewTask();
            },
          );
        });
  }

  void showStatusTaskBottomSheet(TaskData task) {


    showModalBottomSheet(
        context: context,
       useSafeArea: true,
       // isScrollControlled: true,
        builder: (context) {
          return UpdateStatusBottomSheet(task: task, onUpdate: (){
            getNewTask();
          });
        });
  }
}

