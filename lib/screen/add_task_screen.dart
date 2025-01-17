import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/task_controller.dart';
import '../model/task_model.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find<TaskController>();

  // Controllers for text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title Input
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Task Description Input
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 4, // Allow multi-line input for description
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: () {
                _saveTask();
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }

  // Save task to Firestore and local database
  void _saveTask() {
    // Get values from text fields
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    // Check if the title and description are not empty
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar('Error', 'Please provide both title and description');
      return;
    }

    // Create a new task object
    Task newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Unique task ID
      title: title,
      description: description,
      isComplete: false,
      createdAt: DateTime.now(),
    );

    // Use TaskController to save task to Firestore and local database
    taskController.addTask(newTask);

    // Clear text fields after saving
    titleController.clear();
    descriptionController.clear();

    // Show confirmation message
    Get.snackbar('Success', 'Task added successfully');
    Get.back(); // Go back to the previous screen (e.g., HomeScreen)
  }
}
