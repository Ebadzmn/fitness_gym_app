import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';

abstract class TrainingPlanRepository {
  Future<List<TrainingPlanEntity>> getTrainingPlans();
  Future<TrainingPlanEntity> getTrainingPlanById(String id);
}
