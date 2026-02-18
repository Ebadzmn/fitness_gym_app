import 'package:fitness_app/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../domain/entities/daily_entities/nutrition_entity.dart';
import '../../../../../../domain/entities/daily_entities/vital_entity.dart';
import '../../../../../../domain/entities/daily_entities/ped_health_entity.dart';
import '../../../../../../domain/usecases/daily/get_daily_initial_usecase.dart';
import '../../../../../../domain/usecases/daily/get_daily_by_date_usecase.dart';
import '../../../../../../domain/usecases/daily/save_daily_usecase.dart';
import 'daily_event.dart';
import 'daily_state.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DailyBloc extends Bloc<DailyEvent, DailyState> {
  final GetDailyInitialUseCase getInitial;
  final GetDailyByDateUseCase getByDate;
  final SaveDailyUseCase saveDaily;
  final SharedPreferences sharedPreferences;

  DailyBloc({
    required this.getInitial,
    required this.getByDate,
    required this.saveDaily,
    required this.sharedPreferences,
  }) : super(const DailyState()) {
    on<DailyInitRequested>(_onInit);
    on<DailyDateChanged>(_onDateChanged);
    on<WellBeingChanged>(_onWellBeingChanged);
    on<TrainingToggleChanged>(_onTrainingToggleChanged);
    on<TrainingFeedbackChanged>(_onTrainingFeedbackChanged);
    on<DailyNotesChanged>(_onDailyNotesChanged);
    on<NutritionChanged>(_onNutritionChanged);
    on<SavePressed>(_onSavePressed);
    on<VitalTextChanged>(_onVitalTextChanged);
    on<SickChanged>(_onSickChanged);
    on<SleepDurationChanged>(_onSleepDurationChanged);
    on<SleepQualityChanged>(_onSleepQualityChanged);
    on<TrainingPlanToggled>(_onTrainingPlanToggled);
    on<TrainingCardioTypeChanged>(_onTrainingCardioTypeChanged);
    on<TrainingDurationChanged>(_onTrainingDurationChanged);
    on<TrainingIntensityChanged>(_onTrainingIntensityChanged);
    on<NutritionTextChanged>(_onNutritionTextChanged);
    on<WomenCyclePhaseChanged>(_onWomenCyclePhaseChanged);
    on<WomenPmsChanged>(_onWomenPmsChanged);
    on<WomenCrampsChanged>(_onWomenCrampsChanged);
    on<WomenSymptomsChanged>(_onWomenSymptomsChanged);
    on<PedDosageChanged>(_onPedDosageChanged);
    on<PedSideEffectsChanged>(_onPedSideEffectsChanged);
    on<PedBpChanged>(_onPedBpChanged);
  }

  Future<void> _onInit(
    DailyInitRequested event,
    Emitter<DailyState> emit,
  ) async {
    emit(state.copyWith(status: DailyStatus.loading));
    try {
      final data = await getInitial(NoParams());
      emit(
        state.copyWith(status: DailyStatus.success, data: data, isReadOnly: false),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DailyStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDateChanged(
    DailyDateChanged event,
    Emitter<DailyState> emit,
  ) async {
    emit(state.copyWith(status: DailyStatus.loading));
    try {
      final data = await getByDate(event.date);
      emit(
        state.copyWith(status: DailyStatus.success, data: data, isReadOnly: true),
      );
    } catch (e) {
      emit(
        state.copyWith(status: DailyStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onWellBeingChanged(WellBeingChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    final wb = data.wellBeing;
    var updated = wb;
    switch (event.field) {
      case 'energy':
        updated = wb.copyWith(energy: event.value);
        break;
      case 'stress':
        updated = wb.copyWith(stress: event.value);
        break;
      case 'muscleSoreness':
        updated = wb.copyWith(muscleSoreness: event.value);
        break;
      case 'mood':
        updated = wb.copyWith(mood: event.value);
        break;
      case 'motivation':
        updated = wb.copyWith(motivation: event.value);
        break;
    }
    emit(state.copyWith(data: data.copyWith(wellBeing: updated)));
  }

  void _onTrainingToggleChanged(
    TrainingToggleChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    final t = data.training;
    final updated = event.field == 'trainingCompleted'
        ? t.copyWith(trainingCompleted: event.value)
        : t.copyWith(cardioCompleted: event.value);
    emit(state.copyWith(data: data.copyWith(training: updated)));
  }

  void _onTrainingFeedbackChanged(
    TrainingFeedbackChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          training: data.training.copyWith(feedback: event.feedback),
        ),
      ),
    );
  }

  void _onDailyNotesChanged(DailyNotesChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    emit(state.copyWith(data: data.copyWith(notes: event.notes)));
  }

  void _onNutritionChanged(NutritionChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    final n = data.nutrition;
    NutritionEntity updated = n;
    switch (event.field) {
      case 'dietLevel':
        updated = n.copyWith(dietLevel: event.numberValue ?? n.dietLevel);
        break;
      case 'digestion':
        updated = n.copyWith(digestion: event.numberValue ?? n.digestion);
        break;
      case 'hunger':
        updated = n.copyWith(hunger: event.numberValue ?? n.hunger);
        break;
      case 'challenge':
        updated = n.copyWith(challenge: event.textValue ?? n.challenge);
        break;
    }
    emit(state.copyWith(data: data.copyWith(nutrition: updated)));
  }

  Future<void> _onSavePressed(
    SavePressed event,
    Emitter<DailyState> emit,
  ) async {
    final data = state.data;
    if (data == null) return;
    final t = data.training;
    if (t.cardioCompleted) {
      final durOk = RegExp(r'^[0-9]+$').hasMatch(t.duration.trim());
      if (!durOk || t.duration.trim().isEmpty) {
        emit(
          state.copyWith(
            status: DailyStatus.error,
            errorMessage: 'Please enter cardio duration (minutes) as a number',
          ),
        );
        return;
      }
      if (t.cardioType.trim().isEmpty) {
        emit(
          state.copyWith(
            status: DailyStatus.error,
            errorMessage: 'Please select a cardio type',
          ),
        );
        return;
      }
      if (t.intensity < 1 || t.intensity > 10) {
        emit(
          state.copyWith(
            status: DailyStatus.error,
            errorMessage: 'Cardio intensity must be between 1 and 10',
          ),
        );
        return;
      }
    }
    emit(state.copyWith(status: DailyStatus.saving));
    try {
      await saveDaily(data);
      // Cache the weight if it exists
      if (data.vital.weightText.isNotEmpty) {
        await sharedPreferences.setString(
          'cached_weight',
          data.vital.weightText,
        );
      }
      emit(state.copyWith(status: DailyStatus.saved));
    } catch (e) {
      emit(state.copyWith(status: DailyStatus.error, errorMessage: 'Failed'));
    }
  }

  void _onVitalTextChanged(VitalTextChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    final v = data.vital;
    VitalEntity updated = v;
    switch (event.field) {
      case 'weightText':
        updated = v.copyWith(weightText: event.value);
        break;
      case 'waterText':
        updated = v.copyWith(waterText: event.value);
        break;
      case 'bodyTempText':
        updated = v.copyWith(bodyTempText: event.value);
        break;
      case 'activityStepCount':
        updated = v.copyWith(activityStepCount: event.value);
        break;
    }
    emit(state.copyWith(data: data.copyWith(vital: updated)));
  }

  void _onSickChanged(SickChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    emit(state.copyWith(data: data.copyWith(isSick: event.isSick)));
  }

  void _onSleepDurationChanged(
    SleepDurationChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          sleep: data.sleep.copyWith(durationText: event.durationText),
        ),
      ),
    );
  }

  void _onSleepQualityChanged(
    SleepQualityChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(sleep: data.sleep.copyWith(quality: event.quality)),
      ),
    );
  }

  void _onTrainingPlanToggled(
    TrainingPlanToggled event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    final plans = Set<String>.from(data.training.plans);
    if (event.selected) {
      plans.add(event.plan);
    } else {
      plans.remove(event.plan);
    }
    emit(
      state.copyWith(
        data: data.copyWith(training: data.training.copyWith(plans: plans)),
      ),
    );
  }

  void _onTrainingCardioTypeChanged(
    TrainingCardioTypeChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          training: data.training.copyWith(cardioType: event.type),
        ),
      ),
    );
  }

  void _onTrainingDurationChanged(
    TrainingDurationChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          training: data.training.copyWith(duration: event.duration),
        ),
      ),
    );
  }

  void _onTrainingIntensityChanged(
    TrainingIntensityChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          training: data.training.copyWith(intensity: event.intensity),
        ),
      ),
    );
  }

  void _onNutritionTextChanged(
    NutritionTextChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    final n = data.nutrition;
    NutritionEntity updated = n;
    switch (event.field) {
      case 'caloriesText':
        updated = n.copyWith(caloriesText: event.value);
        break;
      case 'carbsText':
        updated = n.copyWith(carbsText: event.value);
        break;
      case 'proteinText':
        updated = n.copyWith(proteinText: event.value);
        break;
      case 'fatsText':
        updated = n.copyWith(fatsText: event.value);
        break;
      case 'saltText':
        updated = n.copyWith(saltText: event.value);
        break;
    }
    emit(state.copyWith(data: data.copyWith(nutrition: updated)));
  }

  void _onWomenCyclePhaseChanged(
    WomenCyclePhaseChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          women: data.women.copyWith(cyclePhase: event.phase),
        ),
      ),
    );
  }

  void _onWomenPmsChanged(WomenPmsChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(women: data.women.copyWith(pms: event.value)),
      ),
    );
  }

  void _onWomenCrampsChanged(
    WomenCrampsChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(women: data.women.copyWith(cramps: event.value)),
      ),
    );
  }

  void _onWomenSymptomsChanged(
    WomenSymptomsChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          women: data.women.copyWith(symptoms: event.symptoms),
        ),
      ),
    );
  }

  void _onPedDosageChanged(PedDosageChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          pedHealth: data.pedHealth.copyWith(dosageTaken: event.taken),
        ),
      ),
    );
  }

  void _onPedSideEffectsChanged(
    PedSideEffectsChanged event,
    Emitter<DailyState> emit,
  ) {
    final data = state.data;
    if (data == null) return;
    emit(
      state.copyWith(
        data: data.copyWith(
          pedHealth: data.pedHealth.copyWith(sideEffects: event.text),
        ),
      ),
    );
  }

  void _onPedBpChanged(PedBpChanged event, Emitter<DailyState> emit) {
    final data = state.data;
    if (data == null) return;
    final p = data.pedHealth;
    PedHealthEntity updated = p;
    switch (event.field) {
      case 'systolicText':
        updated = p.copyWith(systolicText: event.value);
        break;
      case 'diastolicText':
        updated = p.copyWith(diastolicText: event.value);
        break;
      case 'restingHrText':
        updated = p.copyWith(restingHrText: event.value);
        break;
      case 'glucoseText':
        updated = p.copyWith(glucoseText: event.value);
        break;
    }
    emit(state.copyWith(data: data.copyWith(pedHealth: updated)));
  }
}
