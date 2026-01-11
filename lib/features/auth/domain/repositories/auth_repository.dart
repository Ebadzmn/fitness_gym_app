import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login(String email, String password);
  Future<void> forgetPassword(String email);
  Future<void> verifyOtp(String email, String otp);
}
