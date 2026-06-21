import 'exercise.dart';

class WorkoutProgram {
  final int id;
  final String name;
  final String description;
  final String level; // Beginner, Intermediate, Advanced
  final int durationMinutes;
  final List<Exercise> exercises;

  const WorkoutProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.durationMinutes,
    required this.exercises,
  });

  WorkoutProgram copyWith({
    int? id,
    String? name,
    String? description,
    String? level,
    int? durationMinutes,
    List<Exercise>? exercises,
  }) {
    return WorkoutProgram(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exercises: exercises ?? this.exercises,
    );
  }
}
