import 'package:equatable/equatable.dart';
import '../../../../../../domain/entities/daily_entities/daily_tracking_entity.dart';

enum DailyStatus { initial, loading, success, saving, saved, error }

class DailyState extends Equatable {
  final DailyStatus status;
  final DailyTrackingEntity? data;
  final String? errorMessage;

  const DailyState({this.status = DailyStatus.initial, this.data, this.errorMessage});

  DailyState copyWith({DailyStatus? status, DailyTrackingEntity? data, String? errorMessage}) =>
      DailyState(status: status ?? this.status, data: data ?? this.data, errorMessage: errorMessage ?? this.errorMessage);

  @override
  List<Object?> get props => [status, data, errorMessage];
}

