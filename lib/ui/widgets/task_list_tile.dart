import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_model.dart';

class TaskListTile extends StatelessWidget {
  final Color backgroundColor;
  final TaskData data;
  final VoidCallback onDeleteTap,onEditTap;

  const TaskListTile({
    super.key, required this.backgroundColor, required this.data, required this.onDeleteTap, required this.onEditTap,
  });


  @override
  Widget build(BuildContext context) {
    return Material(
      // Added because ListTile paints its background on its Material ancestor
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8,8,8,0),
        child: Card(
          elevation: 1,
          child: ListTile(
            tileColor: Colors.white,
            title: Text(data.title ?? ""),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.description ?? ""),
                Text(data.createdDate ?? ""),
                Row(
                  children:  [
                      Chip(label: Text(data.status ?? "",
                      style: const TextStyle(color: Colors.white),),
                      backgroundColor: backgroundColor,),
                    const Spacer(),
                    IconButton(
                        onPressed: onEditTap,
                        icon: const Icon(
                          Icons.edit_note_outlined,
                          color: Colors.green,
                        )),
                    IconButton(
                        onPressed: onDeleteTap,
                        icon: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}