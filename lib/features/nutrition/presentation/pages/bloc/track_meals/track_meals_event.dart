import 'package:equatable/equatable.dart';

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
