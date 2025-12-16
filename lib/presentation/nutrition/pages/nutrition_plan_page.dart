import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_nutrition_plan_repository.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_plan/nutrition_plan_state.dart';

class NutritionPlanPage extends StatelessWidget {
  const NutritionPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeNutritionPlanRepository(),
      child: Builder(builder: (ctx) {
        final repo = RepositoryProvider.of<FakeNutritionPlanRepository>(ctx);
        return BlocProvider(
          create: (_) => NutritionPlanBloc(
            getPlan: GetNutritionPlanUseCase(repo),
          )..add(const NutritionPlanLoadRequested()),
          child: const _NutritionPlanView(),
        );
      }),
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
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Nutrition Plan', style: AppTextStyle.appbarHeading),
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
        
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _daySegmentControl(),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<NutritionPlanBloc, NutritionPlanState>(
                builder: (context, state) {
                  if (state.status == NutritionPlanStatus.loading ||
                      state.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final plan = state.data!;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _planHeader(plan),
                        SizedBox(height: 12.h),
                        _macroCircles(plan),
                        SizedBox(height: 12.h),
                        ...plan.meals.map((m) => _MealTile(meal: m)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _daySegmentControl() {
    Widget tab(String label, int index) {
      final bool isSelected = _selectedDayIndex == index;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedDayIndex = index;
            });
          },
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF446B36) : Colors.transparent,
              borderRadius: BorderRadius.circular(24.r),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF101021),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.white12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Row(
        children: [
          tab('Training Day', 0),
          tab('Rest Day', 1),
          tab('Special Day', 2),
        ],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF224225),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.restaurant, color: const Color(0xFF82C941), size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${plan.mealsCount} Meals',
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12.sp),
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
                Row(children: [
                  Icon(Icons.water_drop, color: const Color(0xFF4A6CF7), size: 18.sp),
                  SizedBox(width: 6.w),
                  Text('${plan.waterLiters}L\nWater', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
                ]),
                Row(children: [
                  Icon(Icons.local_fire_department, color: const Color(0xFF82C941), size: 18.sp),
                  SizedBox(width: 6.w),
                  Text('${plan.calories}\nCalories', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _macroCircles(NutritionPlanEntity plan) {
  Widget macroItem(String text, String label, Color color , Color fillcolor) {
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
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color(0xFF0F0F1A),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: const Color(0xFF2E2E5D)),
    ),
    padding: EdgeInsets.symmetric(vertical: 14.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        macroItem('${plan.proteinG}g', 'Protein', const Color(0xFF2287DD), const Color(0xFF1B3043)),
        macroItem('${plan.carbsG}g', 'Carbs', const Color(0xFF43A047), const Color(0xFF224225)),
        macroItem('${plan.fatsG}g', 'Fats', const Color(0xFFFF6D00), const Color(0xFF42291A)),
      ],
    ),
  );
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
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF13131F),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 24.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Color(0xFF232333),
                    borderRadius: BorderRadius.circular(6.r),
                 
                  ),
                  child: Center(
                    child: Text(m.timeLabel, style: GoogleFonts.poppins(color: Color(0xFF43A047), fontSize: 12.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    m.title,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: Icon(_expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ],
            ),
          ),
          if (_expanded) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _chip('${m.calories} kcal'),
                  _macroChip('P: ${m.proteinG}g', const Color(0xFF4A6CF7), const Color(0xFF1B3043)),
                  _macroChip('C: ${m.carbsG}g', const Color(0xFF82C941), const Color(0xFF224225)),
                  _macroChip('F: ${m.fatsG}g', const Color(0xFFFF6D00), const Color(0xFF42291A)),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: m.items
                    .map((it) => Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
                              Expanded(
                                child: Text(it, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp)),
    );
  }

  Widget _macroChip(String text, Color color, Color fillcolor) {
    return Container(
      decoration: BoxDecoration(
        color: fillcolor,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp)),
    );
  }
}
