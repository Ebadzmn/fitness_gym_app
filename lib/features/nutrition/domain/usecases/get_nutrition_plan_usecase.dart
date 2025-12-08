import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_nutrition_plan_repository.dart';

class GetNutritionPlanUseCase {
  final FakeNutritionPlanRepository repo;
  GetNutritionPlanUseCase(this.repo);
  Future<NutritionPlanEntity> call() => repo.loadPlan();
}
