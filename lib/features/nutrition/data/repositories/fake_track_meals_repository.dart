import 'dart:async';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';

class FakeTrackMealsRepository {
  Future<List<NutritionMealEntity>> loadMealsForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      NutritionMealEntity(
        timeLabel: '7:00',
        title: 'BREAKFAST',
        calories: 520,
        proteinG: 32,
        carbsG: 70,
        fatsG: 6,
        items: [
          'Oats (30g)',
          'Milk (200ml)',
          'Banana (1 Piece)',
        ],
      ),
      NutritionMealEntity(
        timeLabel: '10:00',
        title: 'SNACK 1',
        calories: 300,
        proteinG: 20,
        carbsG: 30,
        fatsG: 5,
        items: [
          'Greek Yogurt (150g)',
          'Honey (10g)',
        ],
      ),
      NutritionMealEntity(
        timeLabel: '13:00',
        title: 'LUNCH',
        calories: 650,
        proteinG: 40,
        carbsG: 80,
        fatsG: 8,
        items: [
          'Chicken breast (200g)',
          'Rice (150g)',
          'Mixed Vegetables (200g)',
        ],
      ),
    ];
  }
}
