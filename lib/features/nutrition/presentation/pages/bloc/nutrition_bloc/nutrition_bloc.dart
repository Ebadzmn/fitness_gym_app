import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_initial_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_dashboard_entity.dart';
import 'nutrition_event.dart';
import 'nutrition_state.dart';

class NutritionBloc extends Bloc<NutritionEvent, NutritionState> {
  final GetNutritionInitialUseCase getInitial;
  final GetTrackMealsUseCase getTrackMeals;

  NutritionBloc({required this.getInitial, required this.getTrackMeals})
    : super(const NutritionState()) {
    on<NutritionInitRequested>(_onInit);
  }

  Future<void> _onInit(
    NutritionInitRequested event,
    Emitter<NutritionState> emit,
  ) async {
    emit(state.copyWith(status: NutritionStatus.loading));
    try {
      // Load initial data (likely for goals)
      final initialData = await getInitial();

      // Load tracked meals for today
      final trackMealsResult = await getTrackMeals(DateTime.now());

      trackMealsResult.fold(
        (failure) {
          // If tracking fails, we might still show initial data but with error?
          // Or just use initial data's consumed values (which might be 0 or fake).
          // For now, let's just proceed with initialData but log error or maybe show banner.
          // We will preserve initialData but maybe not update consumed if tracking failed.
          emit(
            state.copyWith(status: NutritionStatus.success, data: initialData),
          );
        },
        (trackingData) {
          // Merge tracking data into dashboard entity
          final updatedData = NutritionDashboardEntity(
            caloriesConsumed: trackingData.totals.totalCalories.toInt(),
            caloriesGoal: initialData.caloriesGoal,
            proteinConsumed: trackingData.totals.totalProtein.toInt(),
            proteinGoal: initialData.proteinGoal,
            carbsConsumed: trackingData.totals.totalCarbs.toInt(),
            carbsGoal: initialData.carbsGoal,
            fatConsumed: trackingData.totals.totalFats.toInt(),
            fatGoal: initialData.fatGoal,
          );
          emit(
            state.copyWith(status: NutritionStatus.success, data: updatedData),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NutritionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
