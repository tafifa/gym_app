import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/workout_local_datasource.dart';
import '../../data/datasources/workout_remote_datasource.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../domain/entities/workout_program.dart';
import '../../domain/repositories/workout_repository.dart';
import '../../domain/usecases/get_workout_programs.dart';
import '../../domain/usecases/sync_workout_programs.dart';

/// Provider for the WorkoutRepository
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final store = ref.watch(objectBoxProvider).store;
  final dio = ref.watch(dioProvider);
  
  return WorkoutRepositoryImpl(
    localDataSource: WorkoutLocalDataSourceImpl(store),
    remoteDataSource: WorkoutRemoteDataSourceImpl(dio),
  );
});

/// Riverpod AsyncNotifier to manage workout programs state
class WorkoutProgramsNotifier extends AsyncNotifier<List<WorkoutProgram>> {
  @override
  Future<List<WorkoutProgram>> build() async {
    final repository = ref.watch(workoutRepositoryProvider);
    return GetWorkoutPrograms(repository)();
  }

  /// Trigger sync from remote API and reload the programs
  Future<void> syncWorkouts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(workoutRepositoryProvider);
      await SyncWorkoutPrograms(repository)();
      return GetWorkoutPrograms(repository)();
    });
  }
}

/// Provider for the list of Workout Programs
final workoutProgramsProvider = AsyncNotifierProvider<WorkoutProgramsNotifier, List<WorkoutProgram>>(() {
  return WorkoutProgramsNotifier();
});
