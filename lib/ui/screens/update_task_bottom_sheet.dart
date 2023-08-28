import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/state_manager/update_task_bottom_sheet_controller.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/getx_snackbar.dart';

class UpdateTaskBottomSheet extends StatefulWidget {

  final VoidCallback onUpdate;
  final TaskData task;
  const UpdateTaskBottomSheet({super.key, required this.task, required this.onUpdate});


  @override
  State<UpdateTaskBottomSheet> createState() => _UpdateTaskBottomSheetState();
}

class _UpdateTaskBottomSheetState extends State<UpdateTaskBottomSheet> {


  final UpdateTaskBottomSheetController updateTaskBottomSheetController = Get.put(UpdateTaskBottomSheetController());

  @override
  void initState() {
    updateTaskBottomSheetController.titleController(text: widget.task.title);
    updateTaskBottomSheetController.descriptionController(text: widget.task.description);
    super.initState();
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
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: updateTaskBottomSheetController.titleController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: "Subject",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: updateTaskBottomSheetController.descriptionController,
              keyboardType: TextInputType.text,
              maxLines: 7,
              decoration: const InputDecoration(
                hintText: "Description",
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            GetBuilder<UpdateTaskBottomSheetController>(
              builder: (updateTaskBottomSheetController) {
                return SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: updateTaskBottomSheetController.updateTaskInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        updateTaskBottomSheetController.updateTask().then((value){
                          if (value == true){
                            widget.onUpdate();
                            showGetXSnackBar("Update task","Task updated successfully", Colors.green[500], true);
                          }
                          else{
                            showGetXSnackBar("Update task","Task update failed", Colors.red[500], true);
                          }
                        });
                      },
                      child: const Text("Update"),
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
