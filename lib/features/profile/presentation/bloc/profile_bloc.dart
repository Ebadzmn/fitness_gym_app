import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfile;

  ProfileBloc({required this.getProfile}) : super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoad);
  }

  Future<void> _onLoad(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (data) =>
          emit(state.copyWith(status: ProfileStatus.success, profile: data)),
    );
  }
}
