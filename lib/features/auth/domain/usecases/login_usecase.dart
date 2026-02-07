import '../../../../usecase/usecase.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;
  final String? fcmToken;

  const LoginParams({required this.email, required this.password, this.fcmToken});

  @override
  List<Object?> get props => [email, password, fcmToken];
}

class LoginUseCase extends UseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<AuthEntity> call(LoginParams params) async {
    return await repository.login(
      params.email,
      params.password,
      fcmToken: params.fcmToken,
    );
  }
}
