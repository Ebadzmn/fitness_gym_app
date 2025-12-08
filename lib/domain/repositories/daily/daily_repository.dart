import '../../entities/daily_entities/daily_tracking_entity.dart';

abstract class DailyRepository {
  Future<DailyTrackingEntity> loadInitial();
  Future<void> save(DailyTrackingEntity entity);
}

