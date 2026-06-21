import '../entities/workout_program.dart';
import '../repositories/workout_repository.dart';

class GetWorkoutPrograms {
  final WorkoutRepository repository;

  GetWorkoutPrograms(this.repository);

  Future<List<WorkoutProgram>> call() async {
    return await repository.getWorkoutPrograms();
  }
}
