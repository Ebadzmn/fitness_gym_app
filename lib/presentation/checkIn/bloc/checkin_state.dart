import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkin_entities/check_in_entity.dart';
import '../../../domain/entities/checkin_entities/check_in_date_entity.dart';

enum CheckInViewTab { weekly, old }

enum CheckInStatus { initial, loading, ready, saving, saved, error }

class CheckInState extends Equatable {
  final CheckInStatus status;
  final CheckInEntity? data;
  final CheckInDateEntity? checkInDate;
  final String? errorMessage;
  final CheckInViewTab tab;
  final List<CheckInEntity> history;
  final int historyIndex;

  const CheckInState({
    this.status = CheckInStatus.initial,
    this.data,
    this.checkInDate,
    this.errorMessage,
    this.tab = CheckInViewTab.weekly,
    this.history = const <CheckInEntity>[],
    this.historyIndex = 0,
  });

  CheckInState copyWith({
    CheckInStatus? status,
    CheckInEntity? data,
    CheckInDateEntity? checkInDate,
    String? errorMessage,
    CheckInViewTab? tab,
    List<CheckInEntity>? history,
    int? historyIndex,
  }) => CheckInState(
    status: status ?? this.status,
    data: data ?? this.data,
    checkInDate: checkInDate ?? this.checkInDate,
    errorMessage: errorMessage ?? this.errorMessage,
    tab: tab ?? this.tab,
    history: history ?? this.history,
    historyIndex: historyIndex ?? this.historyIndex,
  );

  @override
  List<Object?> get props => [
    status,
    data,
    checkInDate,
    errorMessage,
    tab,
    history,
    historyIndex,
  ];
}
