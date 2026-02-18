import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_suggestion_entity.dart';

enum TrackMealsStatus { initial, loading, success, failure }

class TrackMealsState extends Equatable {
  final TrackMealsStatus status;
  final DateTime date;
  final List<NutritionMealEntity> meals;
  final String? errorMessage;
  final NutritionPlanEntity? plan;
  final NutritionDailyTrackingEntity? trackingData;
  final Map<int, List<MealSuggestionEntity>> suggestionsByRow;
  final Map<int, String> suggestionQueryByRow;
  final int? suggestionsRowIndex;
  final bool suggestionsLoading;

  const TrackMealsState({
    this.status = TrackMealsStatus.initial,
    required this.date,
    this.meals = const [],
    this.errorMessage,
    this.plan,
    this.trackingData,
    this.suggestionsByRow = const {},
    this.suggestionQueryByRow = const {},
    this.suggestionsRowIndex,
    this.suggestionsLoading = false,
  });

  TrackMealsState copyWith({
    TrackMealsStatus? status,
    DateTime? date,
    List<NutritionMealEntity>? meals,
    String? errorMessage,
    NutritionPlanEntity? plan,
    NutritionDailyTrackingEntity? trackingData,
    Map<int, List<MealSuggestionEntity>>? suggestionsByRow,
    Map<int, String>? suggestionQueryByRow,
    int? suggestionsRowIndex,
    bool? suggestionsLoading,
  }) => TrackMealsState(
    status: status ?? this.status,
    date: date ?? this.date,
    meals: meals ?? this.meals,
    errorMessage: errorMessage ?? this.errorMessage,
    plan: plan ?? this.plan,
    trackingData: trackingData ?? this.trackingData,
    suggestionsByRow: suggestionsByRow ?? this.suggestionsByRow,
    suggestionQueryByRow: suggestionQueryByRow ?? this.suggestionQueryByRow,
    suggestionsRowIndex: suggestionsRowIndex ?? this.suggestionsRowIndex,
    suggestionsLoading: suggestionsLoading ?? this.suggestionsLoading,
  );

  @override
  List<Object?> get props => [
    status,
    date,
    meals,
    errorMessage,
    plan,
    trackingData,
    suggestionsByRow,
    suggestionQueryByRow,
    suggestionsRowIndex,
    suggestionsLoading,
  ];
}
