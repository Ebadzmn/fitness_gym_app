import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';

class GetFoodItemsUseCase {
  final NutritionRepository repo;
  GetFoodItemsUseCase(this.repo);
  Future<List<FoodItemEntity>> call() => repo.getFoodItems();
}
