import 'package:objectbox/objectbox.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout_program.dart';

@Entity()
class WorkoutProgramEntity {
  @Id(assignable: true)
  int id;

  String name;
  String description;
  String level;
  int durationMinutes;

  @Backlink('program')
  final exercises = ToMany<ExerciseEntity>();

  WorkoutProgramEntity({
    this.id = 0,
    required this.name,
    required this.description,
    required this.level,
    required this.durationMinutes,
  });

  // Convert to domain entity
  WorkoutProgram toDomain() {
    return WorkoutProgram(
      id: id,
      name: name,
      description: description,
      level: level,
      durationMinutes: durationMinutes,
      exercises: exercises.map((e) => e.toDomain()).toList(),
    );
  }

  // Create from domain entity
  factory WorkoutProgramEntity.fromDomain(WorkoutProgram program) {
    final entity = WorkoutProgramEntity(
      id: program.id,
      name: program.name,
      description: program.description,
      level: program.level,
      durationMinutes: program.durationMinutes,
    );
    entity.exercises.addAll(program.exercises.map((e) => ExerciseEntity.fromDomain(e)));
    return entity;
  }
}

@Entity()
class ExerciseEntity {
  @Id(assignable: true)
  int id;

  String name;
  String category;
  int sets;
  int reps;
  double defaultWeight;

  final program = ToOne<WorkoutProgramEntity>();

  ExerciseEntity({
    this.id = 0,
    required this.name,
    required this.category,
    required this.sets,
    required this.reps,
    required this.defaultWeight,
  });

  // Convert to domain entity
  Exercise toDomain() {
    return Exercise(
      id: id,
      name: name,
      category: category,
      sets: sets,
      reps: reps,
      defaultWeight: defaultWeight,
    );
  }

  // Create from domain entity
  factory ExerciseEntity.fromDomain(Exercise exercise) {
    return ExerciseEntity(
      id: exercise.id,
      name: exercise.name,
      category: exercise.category,
      sets: exercise.sets,
      reps: exercise.reps,
      defaultWeight: exercise.defaultWeight,
    );
  }
}
