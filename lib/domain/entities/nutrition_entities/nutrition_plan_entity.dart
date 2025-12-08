class NutritionMealEntity {
  final String timeLabel;
  final String title;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatsG;
  final List<String> items;

  const NutritionMealEntity({
    required this.timeLabel,
    required this.title,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.items,
  });
}

class NutritionPlanEntity {
  final String title;
  final int mealsCount;
  final double waterLiters;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatsG;
  final List<NutritionMealEntity> meals;

  const NutritionPlanEntity({
    required this.title,
    required this.mealsCount,
    required this.waterLiters,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.meals,
  });
}
