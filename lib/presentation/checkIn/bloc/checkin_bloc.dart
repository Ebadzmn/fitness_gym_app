import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkin_event.dart';
import 'checkin_state.dart';
import '../../../domain/usecases/checkin/get_checkin_initial_usecase.dart';
import '../../../domain/usecases/checkin/save_checkin_usecase.dart';
import '../../../domain/usecases/checkin/get_checkin_history_usecase.dart';
import '../../../domain/usecases/checkin/get_checkin_date_usecase.dart';
import '../../../domain/entities/checkin_entities/check_in_entity.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final GetCheckInInitialUseCase getInitial;
  final SaveCheckInUseCase saveCheckIn;
  final GetCheckInHistoryUseCase getHistory;
  final GetCheckInDateUseCase getCheckInDate;
  final SharedPreferences sharedPreferences;

  CheckInBloc({
    required this.getInitial,
    required this.saveCheckIn,
    required this.getHistory,
    required this.getCheckInDate,
    required this.sharedPreferences,
  }) : super(const CheckInState()) {
    on<CheckInInitRequested>(_onInit);
    on<CheckInDateRequested>(_onDateRequested);
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
    on<PhotoSelected>(_onPhotoSelected);
    on<PhotoRemoved>(_onPhotoRemoved);
    on<VideoSelected>(_onVideoSelected);
    on<UploadButtonPressed>(_onUploadButtonPressed);
    on<WeightChanged>(_onWeightChanged);
  }

  Future<void> _onInit(
    CheckInInitRequested event,
    Emitter<CheckInState> emit,
  ) async {
    emit(state.copyWith(status: CheckInStatus.loading));
    try {
      final data = await getInitial();
      add(const CheckInDateRequested());
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
      final data = await getHistory(0);
      emit(
        state.copyWith(
          status: CheckInStatus.ready,
          tab: CheckInViewTab.old,
          oldCheckIn: data,
          skip: 0,
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

      // Sync weights to checkInDate after successful save
      final currentDate = state.checkInDate;
      if (currentDate != null) {
        emit(
          state.copyWith(
            checkInDate: currentDate.copyWith(
              currentWeight: d.currentWeight,
              averageWeight: d.averageWeight,
            ),
          ),
        );
      }

      emit(state.copyWith(status: CheckInStatus.saved));
      emit(state.copyWith(status: CheckInStatus.ready));
    } catch (e) {
      emit(
        state.copyWith(status: CheckInStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onHistoryPrev(
    CheckInHistoryPrev event,
    Emitter<CheckInState> emit,
  ) async {
    final newSkip = state.skip + 1;
    emit(state.copyWith(status: CheckInStatus.loading));
    try {
      final data = await getHistory(newSkip);
      if (data != null) {
        emit(
          state.copyWith(
            status: CheckInStatus.ready,
            oldCheckIn: data,
            skip: newSkip,
          ),
        );
      } else {
        // No more data, stay at current skip
        emit(state.copyWith(status: CheckInStatus.ready));
      }
    } catch (e) {
      emit(state.copyWith(status: CheckInStatus.ready));
    }
  }

  Future<void> _onHistoryNext(
    CheckInHistoryNext event,
    Emitter<CheckInState> emit,
  ) async {
    if (state.skip <= 0) return;
    final newSkip = state.skip - 1;
    emit(state.copyWith(status: CheckInStatus.loading));
    try {
      final data = await getHistory(newSkip);
      if (data != null) {
        emit(
          state.copyWith(
            status: CheckInStatus.ready,
            oldCheckIn: data,
            skip: newSkip,
          ),
        );
      } else {
        emit(state.copyWith(status: CheckInStatus.ready));
      }
    } catch (e) {
      emit(state.copyWith(status: CheckInStatus.ready));
    }
  }

  void _onPhotoSelected(PhotoSelected event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    final currentPaths = List<String>.from(d.uploads.picturePaths);
    currentPaths.addAll(event.paths);
    final u = d.uploads.copyWith(picturePaths: currentPaths);
    emit(state.copyWith(data: d.copyWith(uploads: u)));
  }

  void _onPhotoRemoved(PhotoRemoved event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    final currentPaths = List<String>.from(d.uploads.picturePaths);
    currentPaths.remove(event.path);
    final u = d.uploads.copyWith(picturePaths: currentPaths);
    emit(state.copyWith(data: d.copyWith(uploads: u)));
  }

  void _onVideoSelected(VideoSelected event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    final u = d.uploads.copyWith(videoPath: event.path);
    emit(state.copyWith(data: d.copyWith(uploads: u)));
  }

  Future<void> _onDateRequested(
    CheckInDateRequested event,
    Emitter<CheckInState> emit,
  ) async {
    try {
      final dateData = await getCheckInDate();
      emit(state.copyWith(checkInDate: dateData));

      // Cache the current weight
      await sharedPreferences.setString(
        'cached_weight',
        dateData.currentWeight.toString(),
      );

      // Sync weights to form data if available
      final d = state.data;
      if (d != null) {
        emit(
          state.copyWith(
            data: d.copyWith(
              currentWeight: dateData.currentWeight,
              averageWeight: dateData.averageWeight,
            ),
          ),
        );
      }
    } catch (_) {
      // Fail silently or handle error for date fetching
    }
  }

  void _onWeightChanged(WeightChanged event, Emitter<CheckInState> emit) {
    final d = state.data;
    if (d == null) return;
    if (event.field == 'current') {
      emit(state.copyWith(data: d.copyWith(currentWeight: event.value)));
    } else {
      emit(state.copyWith(data: d.copyWith(averageWeight: event.value)));
    }
  }

  Future<void> _onUploadButtonPressed(
    UploadButtonPressed event,
    Emitter<CheckInState> emit,
  ) async {
    final d = state.data;
    if (d == null) return;

    final u = d.uploads.copyWith(
      picturesUploaded: d.uploads.picturePaths.isNotEmpty,
      videoUploaded:
          d.uploads.videoPath != null && d.uploads.videoPath!.isNotEmpty,
    );

    emit(state.copyWith(data: d.copyWith(uploads: u)));
  }
}
