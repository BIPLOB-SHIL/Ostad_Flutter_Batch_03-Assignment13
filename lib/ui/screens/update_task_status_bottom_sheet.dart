import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';

class UpdateStatusBottomSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;

  const UpdateStatusBottomSheet(
      {super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  List<String> taskStatusList = ['New', 'Progress', 'Completed', 'Cancelled'];
  late String _selectedTask;
  bool isUpdateStatusInProgress = false;

  @override
  void initState() {
    _selectedTask = widget.task.status!.toLowerCase();
    super.initState();
  }

  Future<void> updateTask(String taskId, String newStatus) async {
    isUpdateStatusInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.updateTask(taskId, newStatus));
    if (response.isSuccess) {
      widget.onUpdate();
      if (mounted) {
        Navigator.pop(context);
        await showSnackBar(
            "Task status updated successfully", context, Colors.green[500], true);
      }
    } else {
      if (mounted) {
        showSnackBar("Task status update failed", context, Colors.red[500], false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Update Status",
              style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: SizedBox(
            height: 400,
            child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: taskStatusList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      _selectedTask = taskStatusList[index];
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    title: Text(taskStatusList[index].toUpperCase()),
                    trailing: _selectedTask == taskStatusList[index]
                        ? const Icon(Icons.check)
                        : null,
                  );
                }),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Visibility(
              visible: isUpdateStatusInProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ElevatedButton(
                  onPressed: () {
                    updateTask(widget.task.sId!, _selectedTask);
                  }, child: const Text("Update Status")),
            ),
          ),
        )
      ],
    );
  }
}
