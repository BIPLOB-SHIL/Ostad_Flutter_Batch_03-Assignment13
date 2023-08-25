import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_manager_getx/ui/screens/update_task_status_bottom_sheet.dart';
import '../../../data/models/task_list_model.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/task_list_tile.dart';
import '../../widgets/user_profile_banner.dart';
import '../add_new_task_screen.dart';
import '../state_manager/all_task_controller.dart';
import '../state_manager/summary_count_controller.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final SummaryCountController summaryCountController = Get.put<SummaryCountController>(SummaryCountController());
  final AllTaskController allTaskController = Get.put<AllTaskController>(AllTaskController());


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      summaryCountController.getCountSummary();
      allTaskController.getAllTask(Urls.newTask);
    });
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
              child: GetBuilder<SummaryCountController>(
                builder: (summaryCountController) {
                  return summaryCountController.getCountSummaryInProgress
                      ? const LinearProgressIndicator()
                      : Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 80,
                                width: double.infinity,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: summaryCountController.summaryCountModel.data?.length ?? 0,
                                  itemBuilder: (context,index){
                                    return SummaryCard(
                                            number: summaryCountController.summaryCountModel.data![index].sum ?? 0,
                                            title: summaryCountController.summaryCountModel.data![index].sId ?? "New",
                                          );

                                }, separatorBuilder: (BuildContext context, int index){
                                  return const Divider(height: 4,);
                              },
                              )
                              ),
                            )
                          ],
                        );
                }
              ),
            ),
            Expanded(
              child: GetBuilder<AllTaskController>(
                builder: (allTaskController) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      allTaskController.getAllTask(Urls.newTask);
                      summaryCountController.getCountSummary();
                    },
                    child: allTaskController.getProgress
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: allTaskController.taskListModel.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return TaskListTile(
                                backgroundColor: Colors.blue,
                                data: allTaskController.taskListModel.data![index],
                                onDeleteTap: () {
                                  allTaskController.deleteTask(allTaskController.taskListModel.data![index].sId!);
                                },
                                onEditTap: () {
                                  showStatusTaskBottomSheet(
                                      allTaskController.taskListModel.data![index]);
                                },
                              );
                            },
                          ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=>const AddNewTaskScreen());
        },
        child: const Icon(Icons.add,color: Colors.white,),
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
                allTaskController.getAllTask(Urls.newTask);
              });
        });
  }


}
