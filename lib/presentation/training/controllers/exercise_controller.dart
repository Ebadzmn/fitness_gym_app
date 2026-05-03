import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../domain/entities/training_entities/exercise_entity.dart';
import '../../../../features/training/domain/usecases/get_exercises_usecase.dart';

class ExerciseController extends GetxController {
  final GetExercisesUseCase getExercisesUseCase;

  ExerciseController({required this.getExercisesUseCase});

  final RxList<ExerciseEntity> exercises = <ExerciseEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString currentFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  List<ExerciseEntity> get visibleExercises {
    if (searchQuery.value.isEmpty) return exercises;
    
    final query = searchQuery.value.toLowerCase();
    return exercises.where((e) => 
      e.title.toLowerCase().contains(query) || 
      e.category.toLowerCase().contains(query) ||
      e.equipment.toLowerCase().contains(query)
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchInitialExercises();
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
      _fetchMoreExercises();
    }
  }

  Future<void> _fetchInitialExercises() async {
    isLoading.value = true;
    errorMessage.value = '';
    _currentPage = 1;
    _hasMoreData = true;
    exercises.clear();

    final result = await getExercisesUseCase(
      muscleCategory: currentFilter.value == 'All' ? null : currentFilter.value,
      page: _currentPage,
      limit: _limit,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
      },
      (data) {
        if (data.length < _limit) {
          _hasMoreData = false;
        }
        exercises.assignAll(data);
        isLoading.value = false;
      },
    );
  }

  Future<void> _fetchMoreExercises() async {
    isFetchingMore.value = true;
    _currentPage++;

    final result = await getExercisesUseCase(
      muscleCategory: currentFilter.value == 'All' ? null : currentFilter.value,
      page: _currentPage,
      limit: _limit,
    );

    result.fold(
      (failure) {
        _currentPage--;
        isFetchingMore.value = false;
        Get.snackbar('Error', 'Failed to load more exercises');
      },
      (data) {
        if (data.isEmpty || data.length < _limit) {
          _hasMoreData = false;
        }
        exercises.addAll(data);
        isFetchingMore.value = false;
      },
    );
  }

  void setFilter(String filter) {
    if (currentFilter.value == filter) return;
    currentFilter.value = filter;
    _fetchInitialExercises();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
  }
}
