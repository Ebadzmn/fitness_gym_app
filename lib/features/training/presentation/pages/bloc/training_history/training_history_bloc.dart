import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_history_usecase.dart';
import 'training_history_event.dart';
import 'training_history_state.dart';

class TrainingHistoryBloc
    extends Bloc<TrainingHistoryEvent, TrainingHistoryState> {
  final GetTrainingHistoryUseCase getHistory;

  TrainingHistoryBloc({required this.getHistory})
    : super(const TrainingHistoryState()) {
    on<TrainingHistoryLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    TrainingHistoryLoadRequested event,
    Emitter<TrainingHistoryState> emit,
  ) async {
    emit(state.copyWith(status: TrainingHistoryStatus.loading));
    try {
      final history = await getHistory();
      emit(
        state.copyWith(status: TrainingHistoryStatus.success, history: history),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TrainingHistoryStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
