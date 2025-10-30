import 'package:logger/logger.dart';
import 'package:result_dart/result_dart.dart';
import 'package:task_tracker/database.dart';
import 'package:task_tracker/database_service.dart';
import 'package:task_tracker/task.dart';

class TaskRepository {
  late final DatabaseService _databaseService;

  TaskRepository(AppDatabase appDatabase) {
    _databaseService = DatabaseService(appDatabase);
  }

  Future<Result<bool>> insertTask(Task task) async {
    try {
      await _databaseService.insertTask(task);
      logger.i('Task added successfully');
      return const Success(true);
    } catch (e, s) {
      logger.e('Error adding task', error: e, stackTrace: s);
      return Failure(Exception(false));
    }
  }

  Stream<List<Task>> getTasksList() => _databaseService.watchAllTasks();

  Future<Result<bool>> updateTask(Task task) async {
    try {
      final bool result = await _databaseService.updateTask(task);
      if (result) {
        logger.i('Task updated successfully');
        return const Success(true);
      } else {
        logger.w('No rows affected');
        return const Success(false);
      }
    } catch (e, s) {
      logger.e('Error updating Task', error: e, stackTrace: s);
      return (e is Exception) ? Failure(e) : Failure(Exception(e.toString()));
    }
  }

  /// Returns `true` if task was successfully
  Future<Result<bool>> deleteTask(Task task) async {
    try {
      final int result = await _databaseService.deleteTask(task);
      if (result != 0) {
        logger.i('Task deleted successfully');
        return const Success(true);
      } else {
        logger.w('No rows affected');
        return const Success(false);
      }
    } catch (e, s) {
      logger.e('Error deleting Task', error: e, stackTrace: s);
      return (e is Exception) ? Failure(e) : Failure(Exception(e.toString()));
    }
  }
}

final logger = Logger();
