import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/task_model.dart';

class LocalDatabase {
  static Database? _db;

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE tasks (id TEXT PRIMARY KEY, title TEXT, description TEXT, isComplete INTEGER, createdAt TEXT)',
        );
      },
    );
  }

  // Insert task into SQLite database
  Future<void> insertTask(Task task) async {
    await _db?.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all tasks from SQLite
  Future<List<Task>> getTasks() async {
    final result = await _db?.query('tasks') ?? [];
    return result.map((map) => Task.fromMap(map)).toList();
  }

  // Update task in SQLite
  Future<void> updateTask(Task task) async {
    await _db?.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // Delete task from SQLite
  Future<void> deleteTask(String id) async {
    await _db?.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
