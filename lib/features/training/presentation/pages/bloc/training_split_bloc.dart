import 'package:flutter_bloc/flutter_bloc.dart';
import 'training_split_event.dart';
import 'training_split_state.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_split_usecase.dart';

class TrainingSplitBloc extends Bloc<TrainingSplitEvent, TrainingSplitState> {
  final GetTrainingSplitUseCase getSplit;
  TrainingSplitBloc({required this.getSplit}) : super(const TrainingSplitState()) {
    on<TrainingSplitInitRequested>(_onInit);
  }

  Future<void> _onInit(TrainingSplitInitRequested event, Emitter<TrainingSplitState> emit) async {
    emit(state.copyWith(status: TrainingSplitStatus.loading));
    try {
      final items = await getSplit();
      emit(state.copyWith(status: TrainingSplitStatus.ready, items: items));
    } catch (e) {
      emit(state.copyWith(status: TrainingSplitStatus.error, errorMessage: e.toString()));
    }
  }
}
