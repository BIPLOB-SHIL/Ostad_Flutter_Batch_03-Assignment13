import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';
import '../widgets/screen_background.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {

  bool _getInProgressTaskInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getInProgressTask();
    });
  }

  Future<void> getInProgressTask() async{
    _getInProgressTaskInProgress = true;
    if(mounted){
      setState(() {
      });
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.inProgressTask);
    if(response.isSuccess){
      _taskListModel = TaskListModel.fromJson(response.body!);

    }else {
      if(mounted){
        showSnackBar("InProgress task failed", context, Colors.red[500], false);
      }
    }
    _getInProgressTaskInProgress = false;
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
            Expanded(
              child: _getInProgressTaskInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: _taskListModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          backgroundColor: Colors.purple,
                          data: _taskListModel.data![index],
                          onDeleteTap: () {},
                          onEditTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
