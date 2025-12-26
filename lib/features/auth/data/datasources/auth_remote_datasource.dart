import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthModel> login(String email, String password) async {
    final response = await apiClient.post(
      ApiUrls.loginUrl,
      data: {
        'email': email,
        'password': password,
      },
    );
    
    return AuthModel.fromJson(response.data);
  }
}
