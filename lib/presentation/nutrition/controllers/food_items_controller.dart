import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../domain/entities/nutrition_entities/food_item_entity.dart';
import '../../../../features/nutrition/domain/usecases/get_food_items_usecase.dart';

class FoodItemsController extends GetxController {
  final GetFoodItemsUseCase getFoodItemsUseCase;

  FoodItemsController({required this.getFoodItemsUseCase});

  final RxList<FoodItemEntity> foodItems = <FoodItemEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<FoodCategory> currentFilter = FoodCategory.all.obs;
  final RxString searchQuery = ''.obs;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // Derive visible items based on search and current category
  List<FoodItemEntity> get visibleItems {
    var list = foodItems.toList();

    // Local search filtering is removed as it's now server-side
    // if (searchQuery.value.isNotEmpty) {
    //   final query = searchQuery.value.toLowerCase();
    //   list = list.where((item) => 
    //     item.name.toLowerCase().contains(query)
    //   ).toList();
    // }

    if (currentFilter.value == FoodCategory.all) return list;

    return list.where((e) {
      final itemCatStr = e.category.name.toLowerCase().trim();
      
      switch (currentFilter.value) {
        case FoodCategory.protein:
          return itemCatStr.contains('protein') || itemCatStr.contains('meat') || itemCatStr.contains('chicken');
        case FoodCategory.carbs:
          return itemCatStr.contains('carb') || itemCatStr.contains('grain') || itemCatStr.contains('rice');
        case FoodCategory.fats:
          return itemCatStr.contains('fat') || itemCatStr.contains('oil') || itemCatStr.contains('nut');
        case FoodCategory.supplements:
          return itemCatStr.contains('supplement') || itemCatStr.contains('whey');
        case FoodCategory.fruits:
          return itemCatStr.contains('fruit');
        case FoodCategory.vegetables:
          return itemCatStr.contains('vegetable') || itemCatStr.contains('veg');
        case FoodCategory.dairy:
          return itemCatStr.contains('dairy') || itemCatStr.contains('milk') || itemCatStr.contains('cheese');
        case FoodCategory.all:
          return true;
      }
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchInitialFoodItems();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore.value &&
        !isLoading.value &&
        _hasMoreData) {
      _fetchMoreFoodItems();
    }
  }

  Future<void> _fetchInitialFoodItems() async {
    // Only show full-page loader if we don't have any items yet
    if (foodItems.isEmpty) {
      isLoading.value = true;
    }
    
    errorMessage.value = '';
    _currentPage = 1;
    _hasMoreData = true;

    String searchValue = searchQuery.value;
    if (searchValue.isEmpty && currentFilter.value != FoodCategory.all) {
      searchValue = currentFilter.value.name;
    }

    try {
      final result = await getFoodItemsUseCase(
        page: _currentPage,
        limit: _limit,
        search: searchValue,
      );

      if (result.length < _limit) {
        _hasMoreData = false;
      }
      foodItems.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchMoreFoodItems() async {
    isFetchingMore.value = true;
    _currentPage++;

    String searchValue = searchQuery.value;
    if (searchValue.isEmpty && currentFilter.value != FoodCategory.all) {
      searchValue = currentFilter.value.name;
    }

    try {
      final result = await getFoodItemsUseCase(
        page: _currentPage,
        limit: _limit,
        search: searchValue,
      );

      if (result.isEmpty || result.length < _limit) {
        _hasMoreData = false;
      }
      foodItems.addAll(result);
    } catch (e) {
      _currentPage--;
      Get.snackbar('Error', 'Failed to load more food items');
    } finally {
      isFetchingMore.value = false;
    }
  }

  void setFilter(FoodCategory filter) {
    if (currentFilter.value == filter) return;
    currentFilter.value = filter;
    _fetchInitialFoodItems();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchInitialFoodItems();
    });
  }
}
