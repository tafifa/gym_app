import '../entities/workout_program.dart';

abstract class WorkoutRepository {
  /// Fetch stored workout programs from ObjectBox local DB
  Future<List<WorkoutProgram>> getWorkoutPrograms();

  /// Sync/fetch new workout programs from remote API via Dio and save to ObjectBox
  Future<void> syncWorkoutPrograms();
}
