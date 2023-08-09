import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/summary_count_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
         const UserProfileBanner(),
        Padding(
          padding:  const EdgeInsets.all(8.0),
          child: _getCountSummaryInProgress ? const LinearProgressIndicator() : Row(
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
                  title: "Cancelled",
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
            onRefresh: () async{
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
                          );
                        },
                      ),
          ),
        ),
          ],
        ),
      ),
    );
  }
}






