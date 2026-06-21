import '../entities/workout_session.dart';
import '../repositories/history_repository.dart';

class SaveWorkoutSession {
  final HistoryRepository repository;

  SaveWorkoutSession(this.repository);

  Future<void> call(WorkoutSession session) async {
    await repository.saveWorkoutSession(session);
  }
}
