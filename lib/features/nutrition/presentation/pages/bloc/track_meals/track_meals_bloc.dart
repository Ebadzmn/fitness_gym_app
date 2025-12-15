import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/save_track_meal_usecase.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'track_meals_event.dart';
import 'track_meals_state.dart';

class TrackMealsBloc extends Bloc<TrackMealsEvent, TrackMealsState> {
  final GetTrackMealsUseCase getMeals;
  final GetNutritionPlanUseCase getPlan;
  final SaveTrackMealUseCase saveMeal;

  TrackMealsBloc({required DateTime initialDate, required this.getMeals, required this.getPlan, required this.saveMeal})
      : super(TrackMealsState(date: initialDate)) {
    on<TrackMealsLoadRequested>(_onLoad);
    on<TrackMealsDateChanged>(_onDateChanged);
    on<TrackMealsAddMeal>(_onAddMeal);
  }

  Future<void> _onLoad(
    TrackMealsLoadRequested event,
    Emitter<TrackMealsState> emit,
  ) async {
    emit(state.copyWith(status: TrackMealsStatus.loading));
    try {
      final results = await Future.wait([
        getMeals(event.date),
        getPlan(),
      ]);
      final meals = results[0] as List<NutritionMealEntity>;
      final plan = results[1] as NutritionPlanEntity;
      emit(state.copyWith(status: TrackMealsStatus.success, meals: meals, plan: plan));
    } catch (e) {
      emit(state.copyWith(status: TrackMealsStatus.failure, errorMessage: e.toString()));
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
      emit(state.copyWith(status: TrackMealsStatus.failure, errorMessage: e.toString()));
    }
  }
}
