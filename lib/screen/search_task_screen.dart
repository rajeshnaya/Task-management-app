import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';

class SearchTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Tasks')),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(labelText: 'Search by Title'),
            onChanged: (query) {
              taskController.tasks.assignAll(
                taskController.tasks.where(
                        (task) => task.title.toLowerCase().contains(query.toLowerCase())
                ),
              );
            },
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: taskController.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskController.tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: Icon(task.isComplete ? Icons.check : Icons.clear),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
