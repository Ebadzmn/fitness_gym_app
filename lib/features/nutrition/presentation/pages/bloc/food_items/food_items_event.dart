import 'package:equatable/equatable.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';

abstract class FoodItemsEvent extends Equatable {
  const FoodItemsEvent();
  @override
  List<Object?> get props => [];
}

class FoodItemsLoadRequested extends FoodItemsEvent {
  const FoodItemsLoadRequested();
}

class FoodItemsSearchChanged extends FoodItemsEvent {
  final String query;
  const FoodItemsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class FoodItemsFilterChanged extends FoodItemsEvent {
  final FoodCategory category;
  const FoodItemsFilterChanged(this.category);
  @override
  List<Object?> get props => [category];
}
