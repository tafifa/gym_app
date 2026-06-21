import '../../domain/entities/workout_program.dart';
import '../../domain/repositories/workout_repository.dart';
import '../datasources/workout_local_datasource.dart';
import '../datasources/workout_remote_datasource.dart';
import '../models/workout_entities.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutLocalDataSource localDataSource;
  final WorkoutRemoteDataSource remoteDataSource;

  WorkoutRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<WorkoutProgram>> getWorkoutPrograms() async {
    final cached = await localDataSource.getWorkoutPrograms();
    if (cached.isNotEmpty) {
      return cached.map((e) => e.toDomain()).toList();
    } else {
      // If cache is empty, try to sync from remote
      try {
        await syncWorkoutPrograms();
        final newlyCached = await localDataSource.getWorkoutPrograms();
        return newlyCached.map((e) => e.toDomain()).toList();
      } catch (e) {
        return [];
      }
    }
  }

  @override
  Future<void> syncWorkoutPrograms() async {
    final remotePrograms = await remoteDataSource.fetchWorkoutPrograms();
    final entities = remotePrograms.map((p) => WorkoutProgramEntity.fromDomain(p)).toList();
    await localDataSource.saveWorkoutPrograms(entities);
  }
}
