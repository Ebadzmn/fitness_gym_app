import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';

class FakeTrackMealsRepository {
  String _keyForDate(DateTime date) =>
      'track_meals_${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<List<NutritionMealEntity>> loadMealsForDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_keyForDate(date)) ?? const <String>[];
    final persisted = <NutritionMealEntity>[];
    for (final s in saved) {
      try {
        final map = json.decode(s) as Map<String, dynamic>;
        persisted.add(NutritionMealEntity.fromMap(map));
      } catch (_) {}
    }
    final defaults = const [
      NutritionMealEntity(
        timeLabel: '7:00',
        title: 'Meals 1',
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
        title: 'Meals 2',
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
        title: 'Meals 3',
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
    return [...persisted, ...defaults];
  }

  Future<void> saveMealForDate(DateTime date, NutritionMealEntity meal) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyForDate(date);
    final list = prefs.getStringList(key) ?? <String>[];
    list.add(json.encode(meal.toMap()));
    await prefs.setStringList(key, list);
  }
}
