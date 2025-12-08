import 'package:fitness_app/domain/entities/training_entities/training_split_entity.dart';
import 'package:fitness_app/features/training/data/repositories/fake_training_repository.dart';

class GetTrainingSplitUseCase {
  final FakeTrainingRepository repo;
  GetTrainingSplitUseCase(this.repo);
  Future<List<TrainingSplitItem>> call() => repo.loadTrainingSplit();
}
