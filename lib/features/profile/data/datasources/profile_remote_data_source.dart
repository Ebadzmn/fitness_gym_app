import 'package:dio/dio.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../../../../core/network/api_client.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileModel> fetchProfile() async {
    final response = await apiClient.get('${ApiUrls.baseUrl}/profile');

    if (response.data['success'] == true) {
      return ProfileModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}
