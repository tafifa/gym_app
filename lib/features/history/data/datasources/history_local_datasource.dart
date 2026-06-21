import '../models/workout_session_entity.dart';
import '../../../../objectbox.g.dart';

abstract class HistoryLocalDataSource {
  Future<List<WorkoutSessionEntity>> getWorkoutHistory();
  Future<void> saveWorkoutSession(WorkoutSessionEntity session);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final Box<WorkoutSessionEntity> sessionBox;

  HistoryLocalDataSourceImpl(Store store)
      : sessionBox = store.box<WorkoutSessionEntity>();

  @override
  Future<List<WorkoutSessionEntity>> getWorkoutHistory() async {
    // Sort descending by timestamp (newest workouts first)
    final query = sessionBox.query().order(WorkoutSessionEntity_.dateTimestamp, flags: Order.descending).build();
    final results = query.find();
    query.close();
    return results;
  }

  @override
  Future<void> saveWorkoutSession(WorkoutSessionEntity session) async {
    sessionBox.put(session);
  }
}
