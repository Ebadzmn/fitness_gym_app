import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import '../../data/repositories/fake_track_meals_repository.dart';

class SaveTrackMealUseCase {
  final FakeTrackMealsRepository repo;
  SaveTrackMealUseCase(this.repo);
  Future<void> call(DateTime date, NutritionMealEntity meal) => repo.saveMealForDate(date, meal);
}
