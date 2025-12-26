import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/daily_tracking_request_model.dart';
import '../../../../domain/entities/daily_entities/daily_tracking_entity.dart';

abstract class DailyTrackingRemoteDataSource {
  Future<void> submitDailyTracking(DailyTrackingEntity entity);
}

class DailyTrackingRemoteDataSourceImpl implements DailyTrackingRemoteDataSource {
  final ApiClient apiClient;

  DailyTrackingRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> submitDailyTracking(DailyTrackingEntity entity) async {
    final model = DailyTrackingRequestModel(entity);
    await apiClient.post(
      ApiUrls.dailyTrackingPost,
      data: model.toJson(),
    );
  }
}
