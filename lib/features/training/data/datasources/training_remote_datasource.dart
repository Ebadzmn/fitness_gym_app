import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/features/training/data/models/training_plan_model.dart';

abstract class TrainingRemoteDataSource {
  Future<List<TrainingPlanModel>> getTrainingPlans(String userId);
  Future<TrainingPlanModel> getTrainingPlanById(String id);
}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource {
  final ApiClient apiClient;

  TrainingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TrainingPlanModel>> getTrainingPlans(String userId) async {
    final response = await apiClient.get('/training/plan/$userId');

    // Check if the response data is valid and has success true
    if (response.data != null && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => TrainingPlanModel.fromJson(json)).toList();
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to load training plans',
      );
    }
  }

  @override
  Future<TrainingPlanModel> getTrainingPlanById(String id) async {
    final response = await apiClient.get('/training/plan/id/$id');

    if (response.data != null && response.data['success'] == true) {
      final data = response.data['data'];
      return TrainingPlanModel.fromJson(data);
    } else {
      throw Exception(
        response.data['message'] ?? 'Failed to load training plan details',
      );
    }
  }
}
