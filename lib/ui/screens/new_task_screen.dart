import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_getx/ui/screens/update_task_bottom_sheet.dart';
import 'package:task_manager_getx/ui/screens/update_task_status_bottom_sheet.dart';
import '../../data/models/network_response.dart';
import '../../data/models/summary_count_model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/screen_background.dart';
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

  Future<void> getCountSummary() async {
    _getCountSummaryInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.summaryCount);
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
    } else {
      if (mounted) {
        showSnackBar(
            "Get summary count failed", context, Colors.red[500], false);
      }
    }
    _getCountSummaryInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTask() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTask);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        showSnackBar("Get new task failed", context, Colors.red[500], false);
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _getCountSummaryInProgress
                  ? const LinearProgressIndicator()
                  : Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _summaryCountModel.data?.length ?? 0,
                              itemBuilder: (context,index){
                                return SummaryCard(
                                        number: _summaryCountModel.data![index].sum ?? 0,
                                        title: _summaryCountModel.data![index].sId ?? "New",
                                      );

                            }, separatorBuilder: (BuildContext context, int index){
                              return const Divider(height: 4,);
                          },
                          )
                          ),
                        )
                      ],
                    ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getNewTask();
                  getCountSummary();
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
                              showStatusTaskBottomSheet(
                                  _taskListModel.data![index]);
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
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNewTaskScreen()));
        },
        child: const Icon(Icons.add,color: Colors.white,),
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
          return UpdateStatusBottomSheet(
              task: task,
              onUpdate: () {
                getNewTask();
              });
        });
  }
}
