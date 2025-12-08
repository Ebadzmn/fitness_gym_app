import 'package:equatable/equatable.dart';

abstract class CheckInEvent extends Equatable {
  const CheckInEvent();
  @override
  List<Object?> get props => [];
}

class CheckInInitRequested extends CheckInEvent {
  const CheckInInitRequested();
}

class CheckInStepSet extends CheckInEvent {
  final int step;
  const CheckInStepSet(this.step);
  @override
  List<Object?> get props => [step];
}

class CheckInNextPressed extends CheckInEvent {
  const CheckInNextPressed();
}

class AnswerChanged extends CheckInEvent {
  final int index;
  final String value;
  const AnswerChanged(this.index, this.value);
  @override
  List<Object?> get props => [index, value];
}

class WellBeingChanged extends CheckInEvent {
  final String field;
  final double value;
  const WellBeingChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class NutritionNumberChanged extends CheckInEvent {
  final String field;
  final double value;
  const NutritionNumberChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class NutritionTextChanged extends CheckInEvent {
  final String field;
  final String value;
  const NutritionTextChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class UploadsToggled extends CheckInEvent {
  final String field;
  final bool value;
  const UploadsToggled(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingNumberChanged extends CheckInEvent {
  final String field;
  final double value;
  const TrainingNumberChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingToggleChanged extends CheckInEvent {
  final String field;
  final bool value;
  const TrainingToggleChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class TrainingTextChanged extends CheckInEvent {
  final String field;
  final String value;
  const TrainingTextChanged(this.field, this.value);
  @override
  List<Object?> get props => [field, value];
}

class DailyNotesChanged extends CheckInEvent {
  final String value;
  const DailyNotesChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class SubmitPressed extends CheckInEvent {
  const SubmitPressed();
}
