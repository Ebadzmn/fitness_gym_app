import 'dart:async';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';

class FakeNutritionPlanRepository {
  Future<NutritionPlanEntity> loadPlan() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return NutritionPlanEntity(
      title: 'DEVELOPMENT PLAN',
      mealsCount: 7,
      waterLiters: 4.0,
      calories: 3200,
      proteinG: 200,
      carbsG: 200,
      fatsG: 80,
      meals: const [
        NutritionMealEntity(
          timeLabel: '7:00',
          title: 'BREAKFAST',
          calories: 550,
          proteinG: 35,
          carbsG: 75,
          fatsG: 5,
          items: [
            'Oats (30g)',
            'Whey Protein (30g)',
            'Banana (1 Piece)',
            'Almonds (20g)',
          ],
        ),
        NutritionMealEntity(
          timeLabel: '10:00',
          title: 'SNACK 1',
          calories: 550,
          proteinG: 35,
          carbsG: 75,
          fatsG: 5,
          items: [
            'Protein (40g)',
            'Apple (1 Piece)',
          ],
        ),
        NutritionMealEntity(
          timeLabel: '13:00',
          title: 'LUNCH',
          calories: 550,
          proteinG: 35,
          carbsG: 75,
          fatsG: 5,
          items: [
            'Chicken breast (200g)',
            'Rice (150g)',
            'Mixed Vegetables (200g)',
            'Olive oil (10ml)',
          ],
        ),
      ],
    );
  }
}
