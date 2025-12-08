import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plans_usecase.dart';
import 'training_plan_event.dart';
import 'training_plan_state.dart';

class TrainingPlanBloc extends Bloc<TrainingPlanEvent, TrainingPlanState> {
  final GetTrainingPlansUseCase getTrainingPlans;

  TrainingPlanBloc({required this.getTrainingPlans})
    : super(const TrainingPlanState()) {
    on<TrainingPlanLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    TrainingPlanLoadRequested event,
    Emitter<TrainingPlanState> emit,
  ) async {
    emit(state.copyWith(status: TrainingPlanStatus.loading));
    try {
      final plans = await getTrainingPlans();
      emit(state.copyWith(status: TrainingPlanStatus.success, plans: plans));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrainingPlanStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
