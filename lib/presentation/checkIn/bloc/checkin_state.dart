import 'package:equatable/equatable.dart';
import '../../../domain/entities/checkin_entities/check_in_entity.dart';

enum CheckInViewTab { weekly, old }

enum CheckInStatus { initial, loading, ready, saving, saved, error }

class CheckInState extends Equatable {
  final CheckInStatus status;
  final CheckInEntity? data;
  final String? errorMessage;
  final CheckInViewTab tab;
  final List<CheckInEntity> history;
  final int historyIndex;

  const CheckInState({
    this.status = CheckInStatus.initial,
    this.data,
    this.errorMessage,
    this.tab = CheckInViewTab.weekly,
    this.history = const <CheckInEntity>[],
    this.historyIndex = 0,
  });

  CheckInState copyWith({
    CheckInStatus? status,
    CheckInEntity? data,
    String? errorMessage,
    CheckInViewTab? tab,
    List<CheckInEntity>? history,
    int? historyIndex,
  }) =>
      CheckInState(
        status: status ?? this.status,
        data: data ?? this.data,
        errorMessage: errorMessage ?? this.errorMessage,
        tab: tab ?? this.tab,
        history: history ?? this.history,
        historyIndex: historyIndex ?? this.historyIndex,
      );

  @override
  List<Object?> get props => [status, data, errorMessage, tab, history, historyIndex];
}
