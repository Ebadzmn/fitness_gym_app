import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_initial_usecase.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetNutritionInitialUseCase getInitial;

  NutritionBloc({required this.getInitial}) : super(const NutritionState()) {
    on<NutritionInitRequested>(_onInit);
  }

  Future<void> _onInit(
    NutritionInitRequested event,
    Emitter<NutritionState> emit,
  ) async {
    emit(state.copyWith(status: NutritionStatus.loading));
    try {
      final data = await getInitial();
      emit(state.copyWith(status: NutritionStatus.success, data: data));
    } catch (e) {
      emit(state.copyWith(status: NutritionStatus.failure, errorMessage: e.toString()));
    }
  }
}
