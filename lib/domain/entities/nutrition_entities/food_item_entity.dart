enum FoodCategory { all, protein, carbs, fats, supplements }

class FoodItemEntity {
  final String name;
  final FoodCategory category;
  final int caloriesPer100g;
  final int proteinG;
  final int carbsG;
  final int fatsG;
  final int satFatG;
  final int unsatFatG;
  final String? brand;

  const FoodItemEntity({
    required this.name,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinG,
    required this.carbsG,
    required this.fatsG,
    required this.satFatG,
    required this.unsatFatG,
    this.brand,
  });
}
