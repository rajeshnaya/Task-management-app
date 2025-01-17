import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/task_model.dart';

class FirebaseService {
  final CollectionReference taskCollection =
  FirebaseFirestore.instance.collection('tasks');

  // Add a task to Firestore
  Future<void> addTaskToFirestore(Task task) async {
    await taskCollection.doc(task.id).set(task.toMap());
  }

  // Retrieve tasks from Firestore
  Future<List<Task>> getTasksFromFirestore() async {
    QuerySnapshot snapshot = await taskCollection.get();
    return snapshot.docs.map((doc) {
      return Task.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Update task status in Firestore
  Future<void> updateTaskStatus(Task task) async {
    await taskCollection.doc(task.id).update({
      'isComplete': task.isComplete,
    });
  }

  // Delete a task from Firestore
  Future<void> deleteTaskFromFirestore(String taskId) async {
    await taskCollection.doc(taskId).delete();
  }
}
