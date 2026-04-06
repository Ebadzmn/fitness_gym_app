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
    final result = await getTrainingPlans();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TrainingPlanStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (plans) {
        final sortedPlans = plans.toList()
          ..sort((a, b) {
            try {
              final dateA = DateTime.parse(a.date);
              final dateB = DateTime.parse(b.date);
              return dateB.compareTo(dateA);
            } catch (_) {
              return 0;
            }
          });
        emit(
          state.copyWith(status: TrainingPlanStatus.success, plans: sortedPlans),
        );
      },
    );
  }
}
