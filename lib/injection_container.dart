import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'features/auth/data/datasources/firebase_auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_use_case.dart';
import 'features/auth/domain/usecases/sign_in_use_case.dart';
import 'features/auth/domain/usecases/sign_out_use_case.dart';
import 'features/auth/domain/usecases/sign_up_use_case.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/tasks/data/datasources/task_remote_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/domain/repositories/task_repository.dart';
import 'features/tasks/domain/usecases/add_task_usecase.dart';
import 'features/tasks/domain/usecases/delete_task_usecase.dart';
import 'features/tasks/domain/usecases/get_tasks_stream_usecase.dart';
import 'features/tasks/domain/usecases/update_task_usecase.dart';
import 'features/tasks/presentation/blocs/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Auth Feature
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(sl()),
  );

  // ==================================================
  // Task Feature
  // Bloc
  sl.registerFactory(
    () => TaskBloc(
      addTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      deleteTaskUseCase: sl(),
      getTasksByUserUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AddTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetTasksUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(sl()),
  );

  // ==================================================
  // External Dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
