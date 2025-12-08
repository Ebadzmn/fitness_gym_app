import 'package:fitness_app/domain/entities/training_entities/training_history_entity.dart';
import 'package:fitness_app/domain/repositories/training_history_repository.dart';

class GetTrainingHistoryUseCase {
  final TrainingHistoryRepository repository;

  GetTrainingHistoryUseCase(this.repository);

  Future<List<TrainingHistoryEntity>> call() {
    return repository.getHistory();
  }
}
