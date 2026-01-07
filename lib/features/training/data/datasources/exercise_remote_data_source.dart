import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> fetchExercises(String? muscleCategory);
}

class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ApiClient apiClient;

  ExerciseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ExerciseModel>> fetchExercises(String? muscleCategory) async {
    final Map<String, dynamic> queryParams = {};
    if (muscleCategory != null && muscleCategory != 'All') {
      queryParams['musalCategory'] = muscleCategory;
    }

    final response = await apiClient.get(
      ApiUrls.exerciseCoachAthlete,
      queryParameters: queryParams,
    );

    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data']['exercises'];
      return data.map((e) => ExerciseModel.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}
