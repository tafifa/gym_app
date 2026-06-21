import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/history_local_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/get_workout_history.dart';
import '../../domain/usecases/save_workout_session.dart';

/// Provider for the HistoryRepository
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final store = ref.watch(objectBoxProvider).store;
  return HistoryRepositoryImpl(HistoryLocalDataSourceImpl(store));
});

/// Riverpod AsyncNotifier to manage workout history state
class WorkoutHistoryNotifier extends AsyncNotifier<List<WorkoutSession>> {
  @override
  Future<List<WorkoutSession>> build() async {
    final repository = ref.watch(historyRepositoryProvider);
    return GetWorkoutHistory(repository)();
  }

  /// Log a new completed workout session and refresh history
  Future<void> addSession(WorkoutSession session) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.watch(historyRepositoryProvider);
      await SaveWorkoutSession(repository)(session);
      return GetWorkoutHistory(repository)();
    });
  }
}

/// Provider for the list of Workout Sessions (History)
final workoutHistoryProvider = AsyncNotifierProvider<WorkoutHistoryNotifier, List<WorkoutSession>>(() {
  return WorkoutHistoryNotifier();
});
