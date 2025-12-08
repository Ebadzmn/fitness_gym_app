import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';

enum FoodItemsStatus { initial, loading, success, failure }

class FoodItemsState extends Equatable {
  final FoodItemsStatus status;
  final List<FoodItemEntity> items;
  final List<FoodItemEntity> filtered;
  final FoodCategory selected;
  final String query;
  final String? errorMessage;

  const FoodItemsState({
    this.status = FoodItemsStatus.initial,
    this.items = const [],
    this.filtered = const [],
    this.selected = FoodCategory.all,
    this.query = '',
    this.errorMessage,
  });

  FoodItemsState copyWith({
    FoodItemsStatus? status,
    List<FoodItemEntity>? items,
    List<FoodItemEntity>? filtered,
    FoodCategory? selected,
    String? query,
    String? errorMessage,
  }) => FoodItemsState(
        status: status ?? this.status,
        items: items ?? this.items,
        filtered: filtered ?? this.filtered,
        selected: selected ?? this.selected,
        query: query ?? this.query,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, items, filtered, selected, query, errorMessage];
}
