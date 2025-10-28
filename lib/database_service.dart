import 'package:drift/drift.dart';
import 'package:task_tracker/database.dart';
import 'package:task_tracker/task.dart';

class DatabaseService {
  final AppDatabase _database;

  DatabaseService(AppDatabase appDatabase) : _database = appDatabase;

  /// Returns the `id` of the task after insertion
  Future<int> insertTask(Task task) async {
    return _database
        .into(_database.todoItems)
        .insert(
          TodoItemsCompanion(
            content: Value(task.content),
            completed: Value(task.completed),
          ),
        );
  }

  /// Returns stream of the tasks in the database
  Stream<List<Task>> watchAllTasks() => _database
      .select(_database.todoItems)
      .map(
        (entry) => Task(
          id: entry.id,
          content: entry.content,
          completed: entry.completed,
        ),
      )
      .watch();

  /// Returns `true` if any row was affected by the operation
  Future<bool> updateTask(Task task) async => (task.id == null)
      ? false
      : await _database
            .update(_database.todoItems)
            .replace(
              TodoItemsCompanion(
                id: Value(task.id!),
                content: Value(task.content),
                completed: Value(task.completed),
              ),
            );

  // Returns the `id` of the task after deletion
  Future<int> deleteTask(Task task) async => (task.id == null)
      ? 0
      : await (_database.delete(_database.todoItems)..where(
              (tbl) => tbl.id.isValue(task.id!),
            ))
            .go();
}
