import 'package:objectbox/objectbox.dart';
import '../models/workout_entities.dart';

abstract class WorkoutLocalDataSource {
  Future<List<WorkoutProgramEntity>> getWorkoutPrograms();
  Future<void> saveWorkoutPrograms(List<WorkoutProgramEntity> programs);
  Future<void> clearWorkoutPrograms();
}

class WorkoutLocalDataSourceImpl implements WorkoutLocalDataSource {
  final Box<WorkoutProgramEntity> workoutBox;
  final Box<ExerciseEntity> exerciseBox;

  WorkoutLocalDataSourceImpl(Store store)
      : workoutBox = store.box<WorkoutProgramEntity>(),
        exerciseBox = store.box<ExerciseEntity>();

  @override
  Future<List<WorkoutProgramEntity>> getWorkoutPrograms() async {
    return workoutBox.getAll();
  }

  @override
  Future<void> saveWorkoutPrograms(List<WorkoutProgramEntity> programs) async {
    // Clear old data and exercises before saving new synced ones to avoid duplicates
    workoutBox.removeAll();
    exerciseBox.removeAll();
    workoutBox.putMany(programs);
  }

  @override
  Future<void> clearWorkoutPrograms() async {
    workoutBox.removeAll();
    exerciseBox.removeAll();
  }
}
