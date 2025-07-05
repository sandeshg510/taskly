import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase({required this.repository});

  Future<void> call(String taskId, String userId) async {
    return await repository.deleteTask(taskId, userId);
  }
}
