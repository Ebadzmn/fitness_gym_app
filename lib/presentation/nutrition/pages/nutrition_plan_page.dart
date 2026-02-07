import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_state.dart';
import '../../../../injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionPlanPage extends StatelessWidget {
  const NutritionPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NutritionPlanBloc>()..add(const NutritionPlanLoadRequested()),
      child: const _NutritionPlanView(),
    );
  }
}

class _NutritionPlanView extends StatefulWidget {
  const _NutritionPlanView();

  @override
  State<_NutritionPlanView> createState() => _NutritionPlanViewState();
}

class _NutritionPlanViewState extends State<_NutritionPlanView> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F15),
        elevation: 0,
        centerTitle: true,
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
        title: Text(
          localizations.nutritionMenuPlanTitle,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<NutritionPlanBloc, NutritionPlanState>(
        builder: (context, state) {
          if (state.status == NutritionPlanStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NutritionPlanStatus.failure || state.data == null) {
            return Center(
              child: Text(
                'Information not available',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          final plan = state.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _daySegmentControl(context),
                SizedBox(height: 20.h),
                _planHeader(plan),
                SizedBox(height: 12.h),
                _macroCircles(plan),
                SizedBox(height: 20.h),
                _mealsList(plan.meals),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _daySegmentControl(BuildContext context) {
    final days = ['Training Day', 'Rest Day', 'Special Day'];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: List.generate(days.length, (index) {
          final isSelected = index == _selectedDayIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                });
                context.read<NutritionPlanBloc>().add(
                  NutritionPlanTabChanged(index),
                );
              },
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF82C941)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    days[index],
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? const Color(0xFF0F0F15)
                          : Colors.white54,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _planHeader(NutritionPlanEntity plan) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF274128),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF3C7D3D)),
      ),
      padding: EdgeInsets.all(12.sp),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF224225),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: const Color(0xFF82C941),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${plan.mealsCount} Meals',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF182418),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: const Color(0xFF4A6CF7), // Blue
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${plan.waterLiters}L Water',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: const Color(0xFF82C941), // Green
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${plan.calories} kcal',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroCircles(NutritionPlanEntity plan) {
    Widget macroItem(String text, String label, Color color, Color fillcolor) {
      return Column(
        children: [
          Container(
            height: 50.r,
            width: 50.r,
            decoration: BoxDecoration(
              color: fillcolor,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          macroItem(
            '${plan.proteinG}g',
            AppLocalizations.of(context)!.dailyNutritionProteinLabel,
            const Color(0xFF2287DD),
            const Color(0xFF1B3043),
          ),
          macroItem(
            '${plan.carbsG}g',
            AppLocalizations.of(context)!.dailyNutritionCarbsLabel,
            const Color(0xFF43A047),
            const Color(0xFF224225),
          ),
          macroItem(
            '${plan.fatsG}g',
            AppLocalizations.of(context)!.dailyNutritionFatsLabel,
            const Color(0xFFFF6D00),
            const Color(0xFF42291A),
          ),
        ],
      ),
    );
  }

  Widget _mealsList(List<NutritionMealEntity> meals) {
    return Column(children: meals.map((m) => _MealTile(meal: m)).toList());
  }
}

class _MealTile extends StatefulWidget {
  final NutritionMealEntity meal;
  const _MealTile({required this.meal});

  @override
  State<_MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<_MealTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.meal;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Title + Expand Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                m.title, // e.g., "Breakfast"
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 20.sp,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Row 2: Macros summary
          Row(
            children: [
              Text(
                '${m.calories} kcal',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF82C941),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 16.w),
              _miniMacro('P: ${m.proteinG}g', const Color(0xFF2287DD)),
              SizedBox(width: 8.w),
              _miniMacro('C: ${m.carbsG}g', const Color(0xFF43A047)),
              SizedBox(width: 8.w),
              _miniMacro('F: ${m.fatsG}g', const Color(0xFFFF6D00)),
            ],
          ),

          // Expandable: Ingredients list
          if (_expanded) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.white10, height: 1.h),
            SizedBox(height: 16.h),
            ...m.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF82C941),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        '${item.name} (${item.quantity})',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniMacro(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
