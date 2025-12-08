import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';

enum NutritionPlanStatus { initial, loading, success, failure }

class NutritionPlanState extends Equatable {
  final NutritionPlanStatus status;
  final NutritionPlanEntity? data;
  final String? errorMessage;

  const NutritionPlanState({
    this.status = NutritionPlanStatus.initial,
    this.data,
    this.errorMessage,
  });

  NutritionPlanState copyWith({
    NutritionPlanStatus? status,
    NutritionPlanEntity? data,
    String? errorMessage,
  }) => NutritionPlanState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, data, errorMessage];
}
