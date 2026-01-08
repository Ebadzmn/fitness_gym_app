import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';

enum TrackMealsStatus { initial, loading, success, failure }

class TrackMealsState extends Equatable {
  final TrackMealsStatus status;
  final DateTime date;
  final List<NutritionMealEntity> meals;
  final String? errorMessage;
  final NutritionPlanEntity? plan;
  final NutritionDailyTrackingEntity? trackingData;

  const TrackMealsState({
    this.status = TrackMealsStatus.initial,
    required this.date,
    this.meals = const [],
    this.errorMessage,
    this.plan,
    this.trackingData,
  });

  TrackMealsState copyWith({
    TrackMealsStatus? status,
    DateTime? date,
    List<NutritionMealEntity>? meals,
    String? errorMessage,
    NutritionPlanEntity? plan,
    NutritionDailyTrackingEntity? trackingData,
  }) => TrackMealsState(
    status: status ?? this.status,
    date: date ?? this.date,
    meals: meals ?? this.meals,
    errorMessage: errorMessage ?? this.errorMessage,
    plan: plan ?? this.plan,
    trackingData: trackingData ?? this.trackingData,
  );

  @override
  List<Object?> get props => [status, date, meals, errorMessage, plan];
}
