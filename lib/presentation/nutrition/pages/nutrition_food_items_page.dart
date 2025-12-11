import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/food_item_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_food_items_repository.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_food_items_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/food_items/food_items_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/food_items/food_items_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/food_items/food_items_state.dart';

class NutritionFoodItemsPage extends StatelessWidget {
  const NutritionFoodItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeFoodItemsRepository(),
      child: Builder(builder: (ctx) {
        final repo = RepositoryProvider.of<FakeFoodItemsRepository>(ctx);
        return BlocProvider(
          create: (_) => FoodItemsBloc(getItems: GetFoodItemsUseCase(repo))..add(const FoodItemsLoadRequested()),
          child: const _FoodItemsView(),
        );
      }),
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
              child: IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: () {}),
            ),
          ),
        ],
      ),
      body: BlocBuilder<FoodItemsBloc, FoodItemsState>(
        builder: (context, state) {
          if (state.status == FoodItemsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                _searchField(context, state.query),
                SizedBox(height: 12.h),
                _filterRow(context, state.selected),
                SizedBox(height: 12.h),
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
        onChanged: (v) => context.read<FoodItemsBloc>().add(FoodItemsSearchChanged(v)),
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
      return Expanded(
        child: InkWell(
          onTap: () => context.read<FoodItemsBloc>().add(FoodItemsFilterChanged(cat)),
          child: Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2F6D2F)
                  : const Color(0XFF101021),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: isSelected ? const Color(0xFF82C941) : const Color(0xFF2E2E5D)),
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

    return Row(
      children: [
        chip('All', FoodCategory.all),
        SizedBox(width: 8.w),
        chip('Protein', FoodCategory.protein),
        SizedBox(width: 8.w),
        chip('Carbs', FoodCategory.carbs),
        SizedBox(width: 8.w),
        chip('Fats', FoodCategory.fats),
      ],
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
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF2E2E5D)),
                  ),
                  child: Text(
                    _catLabel(item.category),
                    style: GoogleFonts.poppins(color: catColor(item.category), fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pro 100g:', style: GoogleFonts.poppins(color: const Color(0xFF82C941), fontSize: 13.sp)),
                Text('${item.caloriesPer100g} kcal', style: GoogleFonts.poppins(color: const Color(0xFF82C941), fontSize: 13.sp)),
              ],
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _macroChip('P: ${item.proteinG}g', const Color(0xFF4A6CF7)),
                _macroChip('C: ${item.carbsG}g', const Color(0xFF82C941)),
                _macroChip('F: ${item.fatsG}g', const Color(0xFFFF6D00)),
                _macroChip('Sat F: ${item.satFatG}g', const Color(0xFF2E2E5D)),
                _macroChip('Unsat F: ${item.unsatFatG}g', const Color(0xFF82C941)),
              ],
            ),
            if (item.brand != null) ...[
              SizedBox(height: 8.h),
              Text(item.brand!, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp)),
            ],
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
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp)),
    );
  }
}
