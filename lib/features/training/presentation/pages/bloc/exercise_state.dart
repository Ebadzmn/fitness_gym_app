import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/training_entities/exercise_entity.dart';

enum ExerciseStatus { initial, loading, ready, error }

class ExerciseState extends Equatable {
  final ExerciseStatus status;
  final List<ExerciseEntity> all;
  final List<ExerciseEntity> visible;
  final String currentFilter;
  final String query;
  final String? errorMessage;

  const ExerciseState({
    this.status = ExerciseStatus.initial,
    this.all = const [],
    this.visible = const [],
    this.currentFilter = 'All',
    this.query = '',
    this.errorMessage,
  });

  ExerciseState copyWith({
    ExerciseStatus? status,
    List<ExerciseEntity>? all,
    List<ExerciseEntity>? visible,
    String? currentFilter,
    String? query,
    String? errorMessage,
  }) => ExerciseState(
        status: status ?? this.status,
        all: all ?? this.all,
        visible: visible ?? this.visible,
        currentFilter: currentFilter ?? this.currentFilter,
        query: query ?? this.query,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, all, visible, currentFilter, query, errorMessage];
}
