import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/training_entities/training_plan_entity.dart';

enum TrainingPlanStatus { initial, loading, success, failure }

class TrainingPlanState extends Equatable {
  final TrainingPlanStatus status;
  final List<TrainingPlanEntity> plans;
  final String? errorMessage;

  const TrainingPlanState({
    this.status = TrainingPlanStatus.initial,
    this.plans = const [],
    this.errorMessage,
  });

  TrainingPlanState copyWith({
    TrainingPlanStatus? status,
    List<TrainingPlanEntity>? plans,
    String? errorMessage,
  }) {
    return TrainingPlanState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, plans, errorMessage];
}
