import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class GetTrackMealsUseCase {
  final NutritionRepository repo;
  GetTrackMealsUseCase(this.repo);
  Future<List<NutritionMealEntity>> call(DateTime date) =>
      repo.getTrackedMeals(date);
}
