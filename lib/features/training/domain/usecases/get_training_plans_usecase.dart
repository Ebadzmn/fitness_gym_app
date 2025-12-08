import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';

class GetTrainingPlansUseCase {
  final TrainingPlanRepository repository;

  GetTrainingPlansUseCase(this.repository);

  Future<List<TrainingPlanEntity>> call() {
    return repository.getTrainingPlans();
  }
}
