import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/features/nutrition/data/repositories/nutrition_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_food_items_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/food_items/food_items_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/food_items/food_items_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/food_items/food_items_state.dart';
import 'package:fitness_app/injection_container.dart';

class NutritionFoodItemsPage extends StatelessWidget {
  const NutritionFoodItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FoodItemsBloc(
        getItems: GetFoodItemsUseCase(sl<NutritionRepository>()),
      )..add(const FoodItemsLoadRequested()),
      child: const _FoodItemsView(),
    );
  }
}

class _FoodItemsView extends StatelessWidget {
  const _FoodItemsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Food Item', style: AppTextStyle.appbarHeading),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: CircleAvatar(
              backgroundColor: Colors.white10,
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<FoodItemsBloc, FoodItemsState>(
        builder: (context, state) {
          if (state.status == FoodItemsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == FoodItemsStatus.failure) {
            return Center(
              child: Text(
                'Failed to load items',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                _searchField(context, state.query),
                SizedBox(height: 12.h),
                _filterRow(context, state.selected),
                SizedBox(height: 12.h),
                if (state.filtered.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        'No items found',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                else
                  ...state.filtered.map((it) => _FoodItemTile(item: it)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchField(BuildContext context, String query) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: TextField(
        onChanged: (v) =>
            context.read<FoodItemsBloc>().add(FoodItemsSearchChanged(v)),
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search Food...',
          hintStyle: GoogleFonts.poppins(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _filterRow(BuildContext context, FoodCategory selected) {
    Widget chip(String label, FoodCategory cat, {Color? color}) {
      final isSelected = selected == cat;
      return UnconstrainedBox(
        child: InkWell(
          onTap: () =>
              context.read<FoodItemsBloc>().add(FoodItemsFilterChanged(cat)),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 30.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2F6D2F)
                  : const Color(0XFF101021),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF82C941)
                    : const Color(0xFF2E2E5D),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          chip('All', FoodCategory.all),
          chip('Protein', FoodCategory.protein),
          chip('Carbs', FoodCategory.carbs),
          chip('Fats', FoodCategory.fats),
          chip('Fruits', FoodCategory.fruits),
        ],
      ),
    );
  }
}

class _FoodItemTile extends StatelessWidget {
  final FoodItemEntity item;
  const _FoodItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    Color catColor(FoodCategory c) {
      switch (c) {
        case FoodCategory.protein:
          return const Color(0xFF82C941);
        case FoodCategory.carbs:
          return const Color(0xFF4A6CF7);
        case FoodCategory.fats:
          return const Color(0xFFFF6D00);
        case FoodCategory.supplements:
          return const Color(0xFF82C941);
        case FoodCategory.fruits:
          return const Color(0xFFE04F5F); // Reddish for fruits
        case FoodCategory.vegetables:
          return const Color(0xFF4CAF50);
        case FoodCategory.all:
          return Colors.white70;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF2E2E5D)),
                  ),
                  child: Text(
                    _catLabel(item.category),
                    style: GoogleFonts.poppins(
                      color: catColor(item.category),
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Energy (${item.defaultQuantity}):',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF82C941),
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  '${item.calories} kcal',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF82C941),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _macroChip('P: ${item.protein}g', const Color(0xFF4A6CF7)),
                  SizedBox(width: 8.w),
                  _macroChip('C: ${item.carbs}g', const Color(0xFF82C941)),
                  SizedBox(width: 8.w),
                  _macroChip('F: ${item.fats}g', const Color(0xFFFF6D00)),
                  SizedBox(width: 8.w),
                  _macroChip(
                    'Sat F: ${item.saturatedFats}g',
                    const Color(0xFF2E2E5D),
                  ),
                  SizedBox(width: 8.w),
                  _macroChip(
                    'Unsat F: ${item.unsaturatedFats}g',
                    const Color(0xFF82C941),
                  ),
                  SizedBox(width: 8.w),
                  _macroChip('Sug: ${item.sugar}g', const Color(0xFFE04F5F)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _catLabel(FoodCategory c) {
    switch (c) {
      case FoodCategory.protein:
        return 'Protein';
      case FoodCategory.carbs:
        return 'Carbs';
      case FoodCategory.fats:
        return 'Fats';
      case FoodCategory.supplements:
        return 'Supplements';
      case FoodCategory.fruits:
        return 'Fruits';
      case FoodCategory.vegetables:
        return 'Vegetables';
      case FoodCategory.all:
        return 'All';
    }
  }

  Widget _macroChip(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp),
      ),
    );
  }
}
