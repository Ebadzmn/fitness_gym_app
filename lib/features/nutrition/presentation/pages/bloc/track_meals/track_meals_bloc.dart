import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/save_track_meal_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/delete_tracked_food_item_usecase.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'track_meals_event.dart';
import 'track_meals_state.dart';

class TrackMealsBloc extends Bloc<TrackMealsEvent, TrackMealsState> {
  final GetTrackMealsUseCase getMeals;
  final GetNutritionPlanUseCase getPlan;
  final SaveTrackMealUseCase saveMeal;
  final DeleteTrackedFoodItemUseCase deleteFoodItem;

  TrackMealsBloc({
    required DateTime initialDate,
    required this.getMeals,
    required this.getPlan,
    required this.saveMeal,
    required this.deleteFoodItem,
  }) : super(TrackMealsState(date: initialDate)) {
    on<TrackMealsLoadRequested>(_onLoad);
    on<TrackMealsDateChanged>(_onDateChanged);
    on<TrackMealsAddMeal>(_onAddMeal);
    on<TrackMealsDeleteFoodItem>(_onDeleteFoodItem);
  }

  Future<void> _onLoad(
    TrackMealsLoadRequested event,
    Emitter<TrackMealsState> emit,
  ) async {
    emit(state.copyWith(status: TrackMealsStatus.loading));
    try {
      final meals = await getMeals(event.date);
      final planResult = await getPlan('69482a6a6557e1feae3fc446');

      NutritionPlanEntity? planEntity;
      planResult.fold(
        (failure) {
          // If plan fails, we just don't show the header, or we could show partial data.
          // For now, logging/ignoring or setting null is acceptable as meals are primary.
        },
        (response) {
          // Map response totals to NutritionPlanEntity for display
          planEntity = NutritionPlanEntity(
            title: 'Daily Goal',
            mealsCount: response.meals.length,
            waterLiters: 4.0, // Hardcoded
            calories: response.totals.totalCalories,
            proteinG: response.totals.totalProtein,
            carbsG: response.totals.totalCarbs,
            fatsG: response.totals.totalFats,
            meals: response.meals,
          );
        },
      );

      emit(
        state.copyWith(
          status: TrackMealsStatus.success,
          meals: meals,
          plan: planEntity,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDateChanged(
    TrackMealsDateChanged event,
    Emitter<TrackMealsState> emit,
  ) async {
    emit(state.copyWith(date: event.date));
    add(TrackMealsLoadRequested(event.date));
  }

  Future<void> _onAddMeal(
    TrackMealsAddMeal event,
    Emitter<TrackMealsState> emit,
  ) async {
    try {
      await saveMeal(event.date, event.meal);
      add(TrackMealsLoadRequested(event.date));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onDeleteFoodItem(
    TrackMealsDeleteFoodItem event,
    Emitter<TrackMealsState> emit,
  ) async {
    try {
      await deleteFoodItem(event.date, event.mealId, event.foodId);
      add(TrackMealsLoadRequested(event.date));
    } catch (e) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
