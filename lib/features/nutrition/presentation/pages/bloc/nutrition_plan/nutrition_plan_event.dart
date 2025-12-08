import 'package:equatable/equatable.dart';

abstract class NutritionPlanEvent extends Equatable {
  const NutritionPlanEvent();
  @override
  List<Object?> get props => [];
}

class NutritionPlanLoadRequested extends NutritionPlanEvent {
  const NutritionPlanLoadRequested();
}
