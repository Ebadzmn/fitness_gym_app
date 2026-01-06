import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';
import 'package:fitness_app/domain/repositories/training_history/training_plan_repository.dart';

class GetTrainingPlanByIdUseCase {
  final TrainingPlanRepository repository;

  GetTrainingPlanByIdUseCase({required this.repository});

  Future<TrainingPlanEntity> call(String id) async {
    return await repository.getTrainingPlanById(id);
  }
}
