import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/apiUrls/api_urls.dart';
import '../models/nutrition_plan_model.dart';
import '../models/tracked_meal_model.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import '../../../../domain/entities/nutrition_entities/nutrition_response_entity.dart';
import '../../../../domain/entities/nutrition_entities/food_item_entity.dart';
import '../models/nutrition_statistics_model.dart';

abstract class NutritionRemoteDataSource {
  Future<NutritionPlanResponseEntity> fetchNutritionPlan(String userId);
  Future<List<FoodItemEntity>> fetchFoodItems();
  Future<List<NutritionMealEntity>> fetchTrackedMeals(String date);
  Future<void> deleteTrackedFoodItem(String date, String mealId, String foodId);
  Future<void> addFoodItemToMeal(
    String date,
    String mealId,
    Map<String, dynamic> foodItem,
  );
  Future<void> saveTrackedMeal(String date, Map<String, dynamic> mealData);
  Future<NutritionStatisticsModel> fetchNutritionStatistics(String date);
}

class NutritionRemoteDataSourceImpl implements NutritionRemoteDataSource {
  final ApiClient apiClient;

  NutritionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<NutritionPlanResponseEntity> fetchNutritionPlan(String userId) async {
    // Construct the URL: {{baseUrl}}/coach/nutrition/69482a6a6557e1feae3fc446
    final response = await apiClient.get(
      '${ApiUrls.baseUrl}/coach/nutrition/$userId',
    );

    if (response.data['success'] == true) {
      final data = response.data['data'];
      return NutritionPlanResponseModel.fromJson(data);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<List<FoodItemEntity>> fetchFoodItems() async {
    final response = await apiClient.get(ApiUrls.nutritionFood);

    if (response.data['success'] == true) {
      // The API returns a paginated response: data: { items: [], ... }
      final dataObj = response.data['data'];
      final List items = dataObj['items'] ?? [];
      return items.map((e) => FoodItemEntity.fromJson(e)).toList();
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<List<NutritionMealEntity>> fetchTrackedMeals(String date) async {
    // API Call: {{baseUrl}}/track/meal?date=2026-01-06 (Assuming date query param or body)
    // Based on user request "nutrition_track_meals_page this api hit {{baseUrl}}/track/meal and this api response data this ..."
    // The response suggests it returns data for a specific date or all data.
    // If it returns a list of daily data, we should filter or take the relevant one.
    // Let's assume it takes a query param or returns all.
    // Given the response structure has a list of "data", I'll fetch all and filter or the API filters.
    // I'll try passing date as query param if supported, otherwise just fetch.
    // User says "nutrition_track_meals_page this api hit {{baseUrl}}/track/meal". No params mentioned but context implies date.
    // I will pass 'date' as query param to be safe or filter client side.

    final response = await apiClient.get(
      ApiUrls.trackMeal,
      queryParameters: {'date': date},
    );

    if (response.data['success'] == true) {
      final model = TrackedMealResponseModel.fromJson(response.data['data']);
      final dailyData = model.data.firstWhere(
        (element) => element.date == date,
        orElse: () => DailyTrackedData(id: '', date: date, meals: []),
      );
      return dailyData.meals;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<void> deleteTrackedFoodItem(
    String date,
    String mealId,
    String foodId,
  ) async {
    final url = '${ApiUrls.trackMeal}/$date/$mealId';
    final response = await apiClient.delete(
      url,
      queryParameters: {'foodId': foodId},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }

  @override
  Future<void> addFoodItemToMeal(
    String date,
    String mealId,
    Map<String, dynamic> foodItem,
  ) async {
    await apiClient.post(
      '${ApiUrls.trackMeal}/$mealId/food', // Assumption based on pattern, adjusted to match server
      data: {...foodItem, 'date': date},
    );
  }

  @override
  Future<void> saveTrackedMeal(
    String date,
    Map<String, dynamic> mealData,
  ) async {
    await apiClient.post(ApiUrls.trackMeal, data: {...mealData, 'date': date});
  }

  @override
  Future<NutritionStatisticsModel> fetchNutritionStatistics(String date) async {
    final response = await apiClient.get(
      ApiUrls.trackMeal,
      queryParameters: {'date': date},
    );

    if (response.data['success'] == true) {
      return NutritionStatisticsModel.fromJson(response.data['data']);
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data['message'],
      );
    }
  }
}
