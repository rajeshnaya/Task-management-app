import 'package:get/get.dart';
import '../model/task_model.dart';
import '../services/firebase_service.dart';
import '../services/local_database.dart';

class TaskController extends GetxController {
  RxList<Task> tasks = <Task>[].obs; // Observable list of tasks

  final FirebaseService firebaseService = FirebaseService();
  final LocalDatabase localDb = LocalDatabase();

  @override
  void onInit() {
    super.onInit();
    _loadTasks();
  }

  // Load tasks from Firestore and local database
  void _loadTasks() async {
    List<Task> taskList = await localDb.getTasks();
    tasks.value = taskList;

    // Optionally sync with Firestore
    firebaseService.getTasksFromFirestore().then((firestoreTasks) {
      tasks.value = firestoreTasks;
    });
  }

  // Add new task
  void addTask(Task task) async {
    await firebaseService.addTaskToFirestore(task);
    await localDb.insertTask(task);
    tasks.add(task);
  }

  // Update task status
  void updateTaskStatus(String taskId, bool isComplete) async {
    Task task = tasks.firstWhere((task) => task.id == taskId);
    task.isComplete = isComplete;

    // Update Firestore and local database
    await firebaseService.updateTaskStatus(task);
    await localDb.updateTask(task);

    // Update the task in the list
    tasks.refresh();
  }

  // Delete task
  void deleteTask(String taskId) async {
    Task task = tasks.firstWhere((task) => task.id == taskId);

    // Remove task from Firestore and local database
    await firebaseService.deleteTaskFromFirestore(taskId);
    await localDb.deleteTask(taskId);

    // Remove from the observable list
    tasks.removeWhere((task) => task.id == taskId);
  }
}
