import 'dart:async';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';

class FakeFoodItemsRepository {
  Future<List<FoodItemEntity>> loadItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      FoodItemEntity(
        name: 'CHICKEN BREAST',
        category: FoodCategory.protein,
        caloriesPer100g: 165,
        proteinG: 35,
        carbsG: 0,
        fatsG: 2,
        satFatG: 0,
        unsatFatG: 1,
      ),
      FoodItemEntity(
        name: 'RICE COOKED',
        category: FoodCategory.carbs,
        caloriesPer100g: 165,
        proteinG: 3,
        carbsG: 28,
        fatsG: 1,
        satFatG: 0,
        unsatFatG: 0,
      ),
      FoodItemEntity(
        name: 'AVOCADO',
        category: FoodCategory.fats,
        caloriesPer100g: 160,
        proteinG: 2,
        carbsG: 9,
        fatsG: 15,
        satFatG: 2,
        unsatFatG: 11,
      ),
      FoodItemEntity(
        name: 'WHEY PROTEIN',
        category: FoodCategory.supplements,
        caloriesPer100g: 412,
        proteinG: 80,
        carbsG: 6,
        fatsG: 7,
        satFatG: 3,
        unsatFatG: 2,
        brand: 'Optimum Nutrition',
      ),
    ];
  }
}
