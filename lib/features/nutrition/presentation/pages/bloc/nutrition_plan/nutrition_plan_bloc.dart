import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'nutrition_plan_event.dart';
import 'nutrition_plan_state.dart';

class NutritionPlanBloc extends Bloc<NutritionPlanEvent, NutritionPlanState> {
  final GetNutritionPlanUseCase getPlan;

  NutritionPlanBloc({required this.getPlan}) : super(const NutritionPlanState()) {
    on<NutritionPlanLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    NutritionPlanLoadRequested event,
    Emitter<NutritionPlanState> emit,
  ) async {
    emit(state.copyWith(status: NutritionPlanStatus.loading));
    try {
      final data = await getPlan();
      emit(state.copyWith(status: NutritionPlanStatus.success, data: data));
    } catch (e) {
      emit(state.copyWith(status: NutritionPlanStatus.failure, errorMessage: e.toString()));
    }
  }
}
