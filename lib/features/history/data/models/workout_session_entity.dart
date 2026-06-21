import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import '../../domain/entities/workout_session.dart';

@Entity()
class WorkoutSessionEntity {
  @Id()
  int id;

  String programName;
  int dateTimestamp;
  int durationMinutes;
  String exercisesJson;

  WorkoutSessionEntity({
    this.id = 0,
    required this.programName,
    required this.dateTimestamp,
    required this.durationMinutes,
    required this.exercisesJson,
  });

  // Convert to domain entity
  WorkoutSession toDomain() {
    final List<dynamic> decoded = jsonDecode(exercisesJson) as List<dynamic>;
    final exercises = decoded
        .map((item) => ExerciseLog.fromJson(item as Map<String, dynamic>))
        .toList();

    return WorkoutSession(
      id: id,
      programName: programName,
      dateTime: DateTime.fromMillisecondsSinceEpoch(dateTimestamp),
      durationMinutes: durationMinutes,
      exercises: exercises,
    );
  }

  // Create from domain entity
  factory WorkoutSessionEntity.fromDomain(WorkoutSession session) {
    final exercisesJson = jsonEncode(session.exercises.map((e) => e.toJson()).toList());
    return WorkoutSessionEntity(
      id: session.id,
      programName: session.programName,
      dateTimestamp: session.dateTime.millisecondsSinceEpoch,
      durationMinutes: session.durationMinutes,
      exercisesJson: exercisesJson,
    );
  }
}
