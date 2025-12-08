import 'package:equatable/equatable.dart';

abstract class TrainingPlanEvent extends Equatable {
  const TrainingPlanEvent();

  @override
  List<Object?> get props => [];
}

class TrainingPlanLoadRequested extends TrainingPlanEvent {
  const TrainingPlanLoadRequested();
}
