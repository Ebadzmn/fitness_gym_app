import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/save_track_meal_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/delete_tracked_food_item_usecase.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
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

    final mealsResult = await getMeals(event.date);
    final planResult = await getPlan('69482a6a6557e1feae3fc446');

    NutritionDailyTrackingEntity? trackingData;
    String? errorMessage;

    mealsResult.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (data) {
        trackingData = data;
        // Backward compatibility: use the first day's meals if available
        if (data.data.isNotEmpty) {
          // We need to map TrackingMealEntity to NutritionMealEntity if we want to keep using 'meals' list in UI temporarily
          // Or just leave meals empty and switch UI.
          // Since NutritionMealEntity and TrackingMealEntity are different, we can't just assign.
          // For now, let's leave 'meals' empty or rely on the UI using trackingData.
          // But wait, the state.meals is List<NutritionMealEntity>.
          // TrackingMealEntity is unrelated type.
          // I will NOT try to map it here to avoid complex mapping logic. I will switch the UI to use trackingData.
        }
      },
    );

    if (errorMessage != null) {
      emit(
        state.copyWith(
          status: TrackMealsStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      return;
    }

    NutritionPlanEntity? planEntity;
    planResult.fold(
      (failure) {
        // Ignore plan failure for now logic as before
      },
      (response) {
        planEntity = NutritionPlanEntity(
          title: 'Daily Goal',
          mealsCount: response.meals.length,
          waterLiters: 4.0,
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
        meals: [], // Clearing legacy meals list as we move to trackingData
        plan: planEntity,
        trackingData: trackingData,
      ),
    );
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
