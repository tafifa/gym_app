import '../repositories/workout_repository.dart';

class SyncWorkoutPrograms {
  final WorkoutRepository repository;

  SyncWorkoutPrograms(this.repository);

  Future<void> call() async {
    await repository.syncWorkoutPrograms();
  }
}
