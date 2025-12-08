import 'package:equatable/equatable.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();
  @override
  List<Object?> get props => [];
}

class ExerciseInitRequested extends ExerciseEvent {
  const ExerciseInitRequested();
}

class ExerciseFilterSet extends ExerciseEvent {
  final String filter;
  const ExerciseFilterSet(this.filter);
  @override
  List<Object?> get props => [filter];
}

class ExerciseSearchChanged extends ExerciseEvent {
  final String query;
  const ExerciseSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}
