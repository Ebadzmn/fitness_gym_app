import 'package:flutter_bloc/flutter_bloc.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';
import '../../../domain/usecases/checkin/get_checkin_initial_usecase.dart';
import '../../../domain/usecases/checkin/save_checkin_usecase.dart';
import '../../../domain/usecases/checkin/get_checkin_history_usecase.dart';
import '../../../domain/entities/checkin_entities/check_in_entity.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final GetCheckInInitialUseCase getInitial;
  final SaveCheckInUseCase saveCheckIn;
  final GetCheckInHistoryUseCase getHistory;

  CheckInBloc({
    required this.getInitial,
    required this.saveCheckIn,
    required this.getHistory,
  }) : super(const CheckInState()) {
    on<CheckInInitRequested>(_onInit);
    on<CheckInStepSet>(_onStepSet);
    on<CheckInNextPressed>(_onNextPressed);
    on<CheckInTabSet>(_onTabSet);
    on<AnswerChanged>(_onAnswerChanged);
    on<WellBeingChanged>(_onWellBeingChanged);
    on<NutritionNumberChanged>(_onNutritionNumberChanged);
    on<NutritionTextChanged>(_onNutritionTextChanged);
    on<UploadsToggled>(_onUploadsToggled);
    on<TrainingNumberChanged>(_onTrainingNumberChanged);
    on<TrainingToggleChanged>(_onTrainingToggleChanged);
    on<TrainingTextChanged>(_onTrainingTextChanged);
    on<DailyNotesChanged>(_onDailyNotesChanged);
    on<SubmitPressed>(_onSubmitPressed);
    on<CheckInHistoryPrev>(_onHistoryPrev);
    on<CheckInHistoryNext>(_onHistoryNext);
  }

  Future<void> _onInit(
    CheckInInitRequested event,
    Emitter<CheckInState> emit,
  ) async {
    emit(state.copyWith(status: CheckInStatus.loading));
    try {
      final data = await getInitial();
      emit(
        state.copyWith(
          status: CheckInStatus.ready,
          data: data,
          tab: CheckInViewTab.weekly,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CheckInStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onStepSet(CheckInStepSet event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    emit(state.copyWith(data: d.copyWith(step: event.step)));
  }

  void _onNextPressed(CheckInNextPressed event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    final next = (d.step < 3) ? d.step + 1 : d.step;
    emit(state.copyWith(data: d.copyWith(step: next)));
  }

  Future<void> _onTabSet(
    CheckInTabSet event,
    Emitter<CheckInState> emit,
  ) async {
    if (event.tab == 'weekly') {
      emit(state.copyWith(tab: CheckInViewTab.weekly));
      return;
    }
    emit(state.copyWith(status: CheckInStatus.loading));
    try {
      final items = await getHistory();
      emit(
        state.copyWith(
          status: CheckInStatus.ready,
          tab: CheckInViewTab.old,
          history: items,
          historyIndex: 0,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CheckInStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onAnswerChanged(AnswerChanged event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    if (event.index == 1) {
      emit(state.copyWith(data: d.copyWith(answer1: event.value)));
    } else {
      emit(state.copyWith(data: d.copyWith(answer2: event.value)));
    }
  }

  void _onWellBeingChanged(WellBeingChanged event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    final wb = d.wellBeing;
    CheckInWellBeing updated = wb;
    switch (event.field) {
      case 'energy':
        updated = wb.copyWith(energy: event.value);
        break;
      case 'stress':
        updated = wb.copyWith(stress: event.value);
        break;
      case 'mood':
        updated = wb.copyWith(mood: event.value);
        break;
      case 'sleep':
        updated = wb.copyWith(sleep: event.value);
        break;
    }
    emit(state.copyWith(data: d.copyWith(wellBeing: updated)));
  }

  void _onNutritionNumberChanged(
    NutritionNumberChanged event,
    Emitter<CheckInState> emit,
  ) {
    final d = state.data;
    if (d == null) return;
    final n = d.nutrition;
    CheckInNutrition updated = n;
    switch (event.field) {
      case 'dietLevel':
        updated = n.copyWith(dietLevel: event.value);
        break;
      case 'digestion':
        updated = n.copyWith(digestion: event.value);
        break;
    }
    emit(state.copyWith(data: d.copyWith(nutrition: updated)));
  }

  void _onNutritionTextChanged(
    NutritionTextChanged event,
    Emitter<CheckInState> emit,
  ) {
    final d = state.data;
    if (d == null) return;
    final n = d.nutrition.copyWith(challenge: event.value);
    emit(state.copyWith(data: d.copyWith(nutrition: n)));
  }

  void _onUploadsToggled(UploadsToggled event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    final u = d.uploads;
    CheckInUploads updated = u;
    switch (event.field) {
      case 'picturesUploaded':
        updated = u.copyWith(picturesUploaded: event.value);
        break;
      case 'videoUploaded':
        updated = u.copyWith(videoUploaded: event.value);
        break;
    }
    emit(state.copyWith(data: d.copyWith(uploads: updated)));
  }

  void _onTrainingNumberChanged(
    TrainingNumberChanged event,
    Emitter<CheckInState> emit,
  ) {
    final d = state.data;
    if (d == null) return;
    final t = d.training;
    CheckInTraining updated = t;
    switch (event.field) {
      case 'feelStrength':
        updated = t.copyWith(feelStrength: event.value);
        break;
      case 'pumps':
        updated = t.copyWith(pumps: event.value);
        break;
    }
    emit(state.copyWith(data: d.copyWith(training: updated)));
  }

  void _onTrainingToggleChanged(
    TrainingToggleChanged event,
    Emitter<CheckInState> emit,
  ) {
    final d = state.data;
    if (d == null) return;
    final t = d.training;
    CheckInTraining updated = t;
    switch (event.field) {
      case 'trainingCompleted':
        updated = t.copyWith(trainingCompleted: event.value);
        break;
      case 'cardioCompleted':
        updated = t.copyWith(cardioCompleted: event.value);
        break;
    }
    emit(state.copyWith(data: d.copyWith(training: updated)));
  }

  void _onTrainingTextChanged(
    TrainingTextChanged event,
    Emitter<CheckInState> emit,
  ) {
    final d = state.data;
    if (d == null) return;
    final t = d.training;
    CheckInTraining updated = t;
    switch (event.field) {
      case 'cardioType':
        updated = t.copyWith(cardioType: event.value);
        break;
      case 'cardioDuration':
        updated = t.copyWith(cardioDuration: event.value);
        break;
      case 'feedback':
      default:
        updated = t.copyWith(feedback: event.value);
        break;
    }
    emit(state.copyWith(data: d.copyWith(training: updated)));
  }

  void _onDailyNotesChanged(
    DailyNotesChanged event,
    Emitter<CheckInState> emit,
  ) {
    final d = state.data;
    if (d == null) return;
    emit(state.copyWith(data: d.copyWith(dailyNotes: event.value)));
  }

  Future<void> _onSubmitPressed(
    SubmitPressed event,
    Emitter<CheckInState> emit,
  ) async {
    final d = state.data;
    if (d == null) return;
    emit(state.copyWith(status: CheckInStatus.saving));
    try {
      await saveCheckIn(d);
      emit(state.copyWith(status: CheckInStatus.saved));
      emit(state.copyWith(status: CheckInStatus.ready));
    } catch (e) {
      emit(
        state.copyWith(status: CheckInStatus.error, errorMessage: e.toString()),
      );
    }
  }

  void _onHistoryPrev(
    CheckInHistoryPrev event,
    Emitter<CheckInState> emit,
  ) {
    final list = state.history;
    if (list.isEmpty) return;
    final idx = state.historyIndex;
    if (idx < list.length - 1) {
      emit(state.copyWith(historyIndex: idx + 1));
    }
  }

  void _onHistoryNext(
    CheckInHistoryNext event,
    Emitter<CheckInState> emit,
  ) {
    final list = state.history;
    if (list.isEmpty) return;
    final idx = state.historyIndex;
    if (idx > 0) {
      emit(state.copyWith(historyIndex: idx - 1));
    }
  }
}
