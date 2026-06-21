import '../entities/workout_session.dart';

abstract class HistoryRepository {
  /// Retrieve all logged workout sessions
  Future<List<WorkoutSession>> getWorkoutHistory();

  /// Save a completed workout session
  Future<void> saveWorkoutSession(WorkoutSession session);
}
