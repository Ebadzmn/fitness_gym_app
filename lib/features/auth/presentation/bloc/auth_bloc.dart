import 'package:fitness_app/core/storage/token_storage.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/sync_nutrition_data_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/forget_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final TokenStorage tokenStorage;
  final SyncNutritionDataUseCase syncNutritionDataUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.forgetPasswordUseCase,
    required this.verifyOtpUseCase,
    required this.tokenStorage,
    required this.syncNutritionDataUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgetPasswordRequested>(_onForgetPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyOtpUseCase(
        VerifyOtpParams(email: event.email, otp: event.otp),
      );
      emit(OtpVerificationSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onForgetPasswordRequested(
    ForgetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await forgetPasswordUseCase(ForgetPasswordParams(email: event.email));
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await tokenStorage.clearTokens();
    emit(AuthUnauthenticated());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = tokenStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthAuthenticated());
      // Trigger sync if authenticated
      syncNutritionDataUseCase();
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      await tokenStorage.saveAccessToken(result.token);

      // Trigger sync after successful login
      syncNutritionDataUseCase();

      emit(AuthSuccess(result));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
