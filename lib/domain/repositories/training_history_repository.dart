import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';

abstract class TrainingHistoryRepository {
  Future<List<TrainingHistoryEntity>> getHistory();
}
