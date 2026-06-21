import 'package:dio/dio.dart';
import '../../domain/entities/workout_program.dart';
import '../../domain/entities/exercise.dart';

abstract class WorkoutRemoteDataSource {
  Future<List<WorkoutProgram>> fetchWorkoutPrograms();
}

class WorkoutRemoteDataSourceImpl implements WorkoutRemoteDataSource {
  final Dio dio;

  WorkoutRemoteDataSourceImpl(this.dio);

  @override
  Future<List<WorkoutProgram>> fetchWorkoutPrograms() async {
    try {
      // In a real app, this would query a real endpoint:
      // final response = await dio.get('/workout-programs');
      // For this simple gym app, we mock a remote delay and return standard workout programs
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        const WorkoutProgram(
          id: 1,
          name: "Push Day",
          description: "Focus on chest, shoulders, and triceps.",
          level: "Beginner",
          durationMinutes: 45,
          exercises: [
            Exercise(id: 1, name: "Bench Press", category: "Chest", sets: 3, reps: 10, defaultWeight: 40.0),
            Exercise(id: 2, name: "Overhead Press", category: "Shoulders", sets: 3, reps: 8, defaultWeight: 20.0),
            Exercise(id: 3, name: "Incline Dumbbell Fly", category: "Chest", sets: 3, reps: 12, defaultWeight: 12.0),
            Exercise(id: 4, name: "Tricep Pushdown", category: "Triceps", sets: 3, reps: 12, defaultWeight: 15.0),
          ],
        ),
        const WorkoutProgram(
          id: 2,
          name: "Pull Day",
          description: "Focus on back, biceps, and rear delts.",
          level: "Intermediate",
          durationMinutes: 50,
          exercises: [
            Exercise(id: 5, name: "Lat Pulldown", category: "Back", sets: 4, reps: 10, defaultWeight: 45.0),
            Exercise(id: 6, name: "Bent-Over Row", category: "Back", sets: 3, reps: 8, defaultWeight: 35.0),
            Exercise(id: 7, name: "Barbell Bicep Curl", category: "Biceps", sets: 3, reps: 10, defaultWeight: 20.0),
            Exercise(id: 8, name: "Face Pulls", category: "Shoulders", sets: 3, reps: 15, defaultWeight: 10.0),
          ],
        ),
        const WorkoutProgram(
          id: 3,
          name: "Leg Day",
          description: "Focus on quads, hamstrings, and calves.",
          level: "Advanced",
          durationMinutes: 60,
          exercises: [
            Exercise(id: 9, name: "Barbell Back Squat", category: "Legs", sets: 4, reps: 8, defaultWeight: 60.0),
            Exercise(id: 10, name: "Romanian Deadlift", category: "Legs", sets: 3, reps: 10, defaultWeight: 50.0),
            Exercise(id: 11, name: "Leg Press", category: "Legs", sets: 3, reps: 12, defaultWeight: 100.0),
            Exercise(id: 12, name: "Seated Calf Raise", category: "Legs", sets: 3, reps: 15, defaultWeight: 30.0),
          ],
        ),
      ];
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/workout-programs'),
        error: e,
        message: "Failed to fetch remote workout programs",
      );
    }
  }
}
