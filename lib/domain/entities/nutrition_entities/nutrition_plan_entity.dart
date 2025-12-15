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

  Map<String, dynamic> toMap() => {
        'timeLabel': timeLabel,
        'title': title,
        'calories': calories,
        'proteinG': proteinG,
        'carbsG': carbsG,
        'fatsG': fatsG,
        'items': items,
      };

  factory NutritionMealEntity.fromMap(Map<String, dynamic> map) => NutritionMealEntity(
        timeLabel: map['timeLabel'] as String? ?? '',
        title: map['title'] as String? ?? '',
        calories: (map['calories'] as num?)?.toInt() ?? 0,
        proteinG: (map['proteinG'] as num?)?.toInt() ?? 0,
        carbsG: (map['carbsG'] as num?)?.toInt() ?? 0,
        fatsG: (map['fatsG'] as num?)?.toInt() ?? 0,
        items: (map['items'] as List?)?.map((e) => e.toString()).toList() ?? const <String>[],
      );
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
