import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_food_items_usecase.dart';
import 'food_items_event.dart';
import 'food_items_state.dart';

class FoodItemsBloc extends Bloc<FoodItemsEvent, FoodItemsState> {
  final GetFoodItemsUseCase getItems;

  FoodItemsBloc({required this.getItems}) : super(const FoodItemsState()) {
    on<FoodItemsLoadRequested>(_onLoad);
    on<FoodItemsSearchChanged>(_onSearch);
    on<FoodItemsFilterChanged>(_onFilter);
  }

  Future<void> _onLoad(FoodItemsLoadRequested event, Emitter<FoodItemsState> emit) async {
    emit(state.copyWith(status: FoodItemsStatus.loading));
    try {
      final items = await getItems();
      emit(state.copyWith(status: FoodItemsStatus.success, items: items, filtered: items));
    } catch (e) {
      emit(state.copyWith(status: FoodItemsStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onSearch(FoodItemsSearchChanged event, Emitter<FoodItemsState> emit) {
    final q = event.query.toLowerCase();
    final filtered = state.items.where((it) {
      final matchName = it.name.toLowerCase().contains(q);
      final matchBrand = (it.brand ?? '').toLowerCase().contains(q);
      final matchCat = state.selected == FoodCategory.all || it.category == state.selected;
      return matchCat && (matchName || matchBrand);
    }).toList();
    emit(state.copyWith(query: event.query, filtered: filtered));
  }

  void _onFilter(FoodItemsFilterChanged event, Emitter<FoodItemsState> emit) {
    final filtered = state.items.where((it) {
      final q = state.query.toLowerCase();
      final matchQuery = it.name.toLowerCase().contains(q) || (it.brand ?? '').toLowerCase().contains(q);
      final matchCat = event.category == FoodCategory.all || it.category == event.category;
      return matchCat && matchQuery;
    }).toList();
    emit(state.copyWith(selected: event.category, filtered: filtered));
  }
}
