import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';

abstract class TrackMealsEvent extends Equatable {
  const TrackMealsEvent();
  @override
  List<Object?> get props => [];
}

class TrackMealsLoadRequested extends TrackMealsEvent {
  final DateTime date;
  const TrackMealsLoadRequested(this.date);
  @override
  List<Object?> get props => [date];
}

class TrackMealsDateChanged extends TrackMealsEvent {
  final DateTime date;
  const TrackMealsDateChanged(this.date);
  @override
  List<Object?> get props => [date];
}

class TrackMealsAddMeal extends TrackMealsEvent {
  final DateTime date;
  final NutritionMealEntity meal;
  const TrackMealsAddMeal(this.date, this.meal);
  @override
  List<Object?> get props => [date, meal];
}
