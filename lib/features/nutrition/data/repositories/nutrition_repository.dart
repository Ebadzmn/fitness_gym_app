import 'package:fitness_app/core/apiUrls/api_urls.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';

class NutritionRepository {
  final ApiClient apiClient;

  NutritionRepository({required this.apiClient});

  Future<List<FoodItemEntity>> getFoodItems() async {
    try {
      final response = await apiClient.get(ApiUrls.nutritionFood);
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        if (data != null && data['items'] != null) {
          final List items = data['items'];
          return items.map((e) => FoodItemEntity.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load food items: $e');
    }
  }
}
