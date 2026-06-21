import '../entities/workout_session.dart';
import '../repositories/history_repository.dart';

class GetWorkoutHistory {
  final HistoryRepository repository;

  GetWorkoutHistory(this.repository);

  Future<List<WorkoutSession>> call() async {
    return await repository.getWorkoutHistory();
  }
}
