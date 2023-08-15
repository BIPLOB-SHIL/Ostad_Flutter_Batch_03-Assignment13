import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/show_snackbar.dart';

class UpdateTaskBottomSheet extends StatefulWidget {

  final VoidCallback onUpdate;
  final TaskData task;
  const UpdateTaskBottomSheet({super.key, required this.task, required this.onUpdate});


  @override
  State<UpdateTaskBottomSheet> createState() => _UpdateTaskBottomSheetState();
}

class _UpdateTaskBottomSheetState extends State<UpdateTaskBottomSheet> {

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _updateTaskInprogress =false;


  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    super.initState();
  }

  Future<void> updateTask() async {
    _updateTaskInprogress = true;
    if (mounted) {
      setState(() {});
    }

    Map<String, dynamic> responseBody = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
    };

    // need to change
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTaskUrl, responseBody);

    _updateTaskInprogress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      _titleController.clear();
      _descriptionController.clear();
      if (mounted) {
        widget.onUpdate();
        showSnackBar(
            "Task updated successfully", context, Colors.green[500], true);
      }
      else {
        if (mounted) {
          showSnackBar("Task update failed", context, Colors.red[500], true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Update Task",
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Subject",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              maxLines: 7,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
              child: Visibility(
                visible: _updateTaskInprogress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                  onPressed: () {
                  //  updateTask();
                  },
                  child: const Text("Update"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
