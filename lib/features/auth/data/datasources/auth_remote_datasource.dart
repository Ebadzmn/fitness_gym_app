import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
  Future<void> forgetPassword(String email);
  Future<void> verifyOtp(String email, String otp);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthModel> login(String email, String password) async {
    final response = await apiClient.post(
      ApiUrls.loginUrl,
      data: {'email': email, 'password': password},
    );

    return AuthModel.fromJson(response.data);
  }

  @override
  Future<void> forgetPassword(String email) async {
    await apiClient.post(ApiUrls.forgetPasswordUrl, data: {'email': email});
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    await apiClient.post(
      ApiUrls.verifyEmailUrl,
      data: {'email': email, 'oneTimeCode': otp},
    );
  }
}
