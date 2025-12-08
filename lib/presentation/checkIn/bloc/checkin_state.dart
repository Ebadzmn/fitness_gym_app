import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkin_entities/check_in_entity.dart';

enum CheckInStatus { initial, loading, ready, saving, saved, error }

class CheckInState extends Equatable {
  final CheckInStatus status;
  final CheckInEntity? data;
  final String? errorMessage;

  const CheckInState({this.status = CheckInStatus.initial, this.data, this.errorMessage});

  CheckInState copyWith({CheckInStatus? status, CheckInEntity? data, String? errorMessage}) =>
      CheckInState(status: status ?? this.status, data: data ?? this.data, errorMessage: errorMessage ?? this.errorMessage);

  @override
  List<Object?> get props => [status, data, errorMessage];
}
