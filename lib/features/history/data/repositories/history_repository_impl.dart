import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';
import '../models/workout_session_entity.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;

  HistoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<WorkoutSession>> getWorkoutHistory() async {
    final entities = await localDataSource.getWorkoutHistory();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    final entity = WorkoutSessionEntity.fromDomain(session);
    await localDataSource.saveWorkoutSession(entity);
  }
}
