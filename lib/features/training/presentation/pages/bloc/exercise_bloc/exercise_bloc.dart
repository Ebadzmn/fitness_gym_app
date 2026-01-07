import 'package:flutter_bloc/flutter_bloc.dart';
import 'exercise_event.dart';
import 'exercise_state.dart';
import '../../../../domain/usecases/get_exercises_usecase.dart';
import '../../../../../../domain/entities/training_entities/exercise_entity.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExercisesUseCase getExercises;
  ExerciseBloc({required this.getExercises}) : super(const ExerciseState()) {
    on<ExerciseInitRequested>(_onInit);
    on<ExerciseFilterSet>(_onFilter);
    on<ExerciseSearchChanged>(_onSearch);
  }

  Future<void> _onInit(
    ExerciseInitRequested event,
    Emitter<ExerciseState> emit,
  ) async {
    emit(state.copyWith(status: ExerciseStatus.loading));
    final result = await getExercises();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (all) => emit(
        _apply(
          all: all,
          filter: state.currentFilter,
          query: state.query,
        ).copyWith(status: ExerciseStatus.ready),
      ),
    );
  }

  Future<void> _onFilter(
    ExerciseFilterSet event,
    Emitter<ExerciseState> emit,
  ) async {
    // If selecting 'All', fetch all or default. If specific, fetch specific.
    // Update state to show loading or keep current content while loading
    emit(
      state.copyWith(
        currentFilter: event.filter,
        status: ExerciseStatus.loading,
      ),
    );

    final result = await getExercises(
      muscleCategory: event.filter == 'All' ? null : event.filter,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExerciseStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (all) => emit(
        _apply(
          all: all,
          filter: event.filter,
          query: state.query,
        ).copyWith(status: ExerciseStatus.ready),
      ),
    );
  }

  void _onSearch(ExerciseSearchChanged event, Emitter<ExerciseState> emit) {
    emit(
      _apply(
        all: state.all,
        filter: state.currentFilter,
        query: event.query,
      ).copyWith(query: event.query),
    );
  }

  ExerciseState _apply({
    required List<ExerciseEntity> all,
    required String filter,
    required String query,
  }) {
    final List<ExerciseEntity> list = all;
    final filtered = list.where((e) {
      final matchFilter =
          filter == 'All' || e.category.toLowerCase() == filter.toLowerCase();
      final q = query.trim().toLowerCase();
      final matchQuery =
          q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.tags.any((t) => t.toLowerCase().contains(q));
      return matchFilter && matchQuery;
    }).toList();
    return state.copyWith(all: list, visible: filtered);
  }
}
