import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_supplements_usecase.dart';
import 'nutrition_supplement_event.dart';
import 'nutrition_supplement_state.dart';

class NutritionSupplementBloc
    extends Bloc<NutritionSupplementEvent, NutritionSupplementState> {
  final GetSupplementsUseCase getSupplements;

  NutritionSupplementBloc({required this.getSupplements})
    : super(const NutritionSupplementState()) {
    on<NutritionSupplementLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    NutritionSupplementLoadRequested event,
    Emitter<NutritionSupplementState> emit,
  ) async {
    emit(state.copyWith(status: NutritionSupplementStatus.loading));
    final result = await getSupplements();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: NutritionSupplementStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(
        state.copyWith(status: NutritionSupplementStatus.success, data: data),
      ),
    );
  }
}
