import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/value/colors.dart';
import '../controller/task_controller.dart';
import '../controller/auth_controller.dart';
import '../model/task_model.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskController taskController = Get.find<TaskController>();
  final AuthController authController = Get.find<AuthController>();

  String searchQuery = '';
  String filterOption = 'All'; // All, Completed, Incomplete

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        actions: [
          // Search Field in AppBar
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Filter Dropdown in AppBar
          DropdownButton<String>(
            value: filterOption,
            dropdownColor: AppColors.mainColor,
            style: const TextStyle(color: AppColors.whiteColor),
            underline: Container(),
            icon: const Icon(Icons.filter_list, color: AppColors.whiteColor),
            onChanged: (value) {
              setState(() {
                filterOption = value!;
              });
            },
            items: ['All', 'Completed', 'Incomplete']
                .map(
                  (option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ),
            )
                .toList(),
          ),
          // Logout Button in AppBar
          IconButton(
            icon: const Icon(Icons.logout,color: AppColors.whiteColor,),
            tooltip: 'Logout',
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        // Filter tasks dynamically
        var filteredTasks = taskController.tasks.where((task) {
          // Apply search filter
          if (!task.title.toLowerCase().contains(searchQuery)) {
            return false;
          }
          // Apply completion status filter
          if (filterOption == 'Completed' && !task.isComplete) {
            return false;
          }
          if (filterOption == 'Incomplete' && task.isComplete) {
            return false;
          }
          return true;
        }).toList();

        if (filteredTasks.isEmpty) {
          return const Center(child: Text('No tasks available'));
        }

        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            Task task = filteredTasks[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Container(
                  height: 100.0,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    trailing: SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Checkbox(
                              value: task.isComplete,
                              onChanged: (bool? value) {
                                taskController.updateTaskStatus(
                                    task.id, value!);
                              },
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                taskController.deleteTask(task.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.mainColor,
        onPressed: () {
          // Navigate to the AddTaskScreen when the floating button is pressed
          Get.to(() => AddTaskScreen());
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
