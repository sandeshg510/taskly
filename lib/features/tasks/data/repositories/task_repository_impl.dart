import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_manager/features/tasks/domain/repositories/task_repository.dart';

import '../../domain/entities/task_entity.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<void> createTask(TaskEntity task) async {
  //   return remoteDataSource.createTask(task);
  // }
  final firestore = FirebaseFirestore.instance;
  @override
  Future<void> createTask(TaskEntity task) async {
    return remoteDataSource.createTask(task);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    return remoteDataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId, String userId) async {
    return remoteDataSource.deleteTask(taskId, userId);
  }

  @override
  Future<List<TaskEntity>> getUserTasks(String userId) {
    return remoteDataSource.getTasksByUser(userId);
  }
}
