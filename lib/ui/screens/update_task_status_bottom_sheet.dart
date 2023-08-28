import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/state_manager/update_task_status_bottom_sheet_controller.dart';
import 'package:task_manager_getx/ui/utils/getx_snackbar.dart';
import '../../data/models/task_list_model.dart';


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


  final UpdateTaskStatusBottomSheetController updateTaskStatusBottomSheetController = Get.put(UpdateTaskStatusBottomSheetController());

  @override
  void initState() {
    _selectedTask = widget.task.status!.toLowerCase();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "UPDATE STATUS",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 25,
            color: Colors.black),
          ),
        ),
        Expanded(
          child: SizedBox(
            child: ListView.builder(
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
                        ? const Icon(Icons.check,color: Colors.black,)
                        : null,
                    leading: const Icon(Icons.task,color: Colors.black,),
                  );
                }),
          ),
        ),
        GetBuilder<UpdateTaskStatusBottomSheetController>(
          builder: (updateTaskStatusBottomSheetController) {
            return SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                  visible: updateTaskStatusBottomSheetController.isUpdateStatusInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                    ),
                      onPressed: () {
                        updateTaskStatusBottomSheetController.updateTask(widget.task.sId!, _selectedTask).then((value)
                        {
                          if (value == true){
                            widget.onUpdate();
                            Get.back();
                            showGetXSnackBar("Status","Task status updated successfully" ,Colors.green[500], true);
                          }
                          else{
                            showGetXSnackBar("Status","Task status update failed", Colors.red[500], false);
                          }

                        });
                      }, child: const Text("Update Status")),
                ),
              ),
            );
          }
        )
      ],
    );
  }
}
