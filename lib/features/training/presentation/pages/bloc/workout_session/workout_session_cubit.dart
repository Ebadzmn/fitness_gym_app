import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_plan_by_id_usecase.dart';
import 'workout_session_state.dart';

class WorkoutSessionCubit extends Cubit<WorkoutSessionState> {
  final GetTrainingPlanByIdUseCase getTrainingPlanById;

  WorkoutSessionCubit({required this.getTrainingPlanById})
    : super(WorkoutSessionInitial());

  Future<void> loadWorkoutSession(String planId) async {
    emit(WorkoutSessionLoading());
    try {
      final plan = await getTrainingPlanById(planId);
      emit(WorkoutSessionLoaded(plan: plan));
    } catch (e) {
      emit(WorkoutSessionError(message: e.toString()));
    }
  }
}
