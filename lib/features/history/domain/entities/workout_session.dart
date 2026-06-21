class SetLog {
  final int reps;
  final double weight;

  const SetLog({
    required this.reps,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
        'reps': reps,
        'weight': weight,
      };

  factory SetLog.fromJson(Map<String, dynamic> json) => SetLog(
        reps: json['reps'] as int,
        weight: (json['weight'] as num).toDouble(),
      );
}

class ExerciseLog {
  final String exerciseName;
  final String category;
  final List<SetLog> sets;

  const ExerciseLog({
    required this.exerciseName,
    required this.category,
    required this.sets,
  });

  Map<String, dynamic> toJson() => {
        'exerciseName': exerciseName,
        'category': category,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  factory ExerciseLog.fromJson(Map<String, dynamic> json) => ExerciseLog(
        exerciseName: json['exerciseName'] as String,
        category: json['category'] as String,
        sets: (json['sets'] as List<dynamic>)
            .map((s) => SetLog.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}

class WorkoutSession {
  final int id;
  final String programName;
  final DateTime dateTime;
  final int durationMinutes;
  final List<ExerciseLog> exercises;

  const WorkoutSession({
    required this.id,
    required this.programName,
    required this.dateTime,
    required this.durationMinutes,
    required this.exercises,
  });

  WorkoutSession copyWith({
    int? id,
    String? programName,
    DateTime? dateTime,
    int? durationMinutes,
    List<ExerciseLog>? exercises,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      programName: programName ?? this.programName,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      exercises: exercises ?? this.exercises,
    );
  }
}
