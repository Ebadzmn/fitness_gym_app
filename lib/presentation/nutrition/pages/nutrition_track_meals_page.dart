import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_track_meals_repository.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_nutrition_plan_repository.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_track_meals_usecase.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_plan_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_state.dart';

class NutritionTrackMealsPage extends StatelessWidget {
  const NutritionTrackMealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final initialDate = DateTime.now();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => FakeTrackMealsRepository()),
        RepositoryProvider(create: (_) => FakeNutritionPlanRepository()),
      ],
      child: Builder(builder: (ctx) {
        final mealsRepo = RepositoryProvider.of<FakeTrackMealsRepository>(ctx);
        final planRepo = RepositoryProvider.of<FakeNutritionPlanRepository>(ctx);
        return BlocProvider(
          create: (_) => TrackMealsBloc(
            initialDate: initialDate,
            getMeals: GetTrackMealsUseCase(mealsRepo),
            getPlan: GetNutritionPlanUseCase(planRepo),
          )..add(TrackMealsLoadRequested(initialDate)),
          child: const _TrackMealsView(),
        );
      }),
    );
  }
}

class _TrackMealsView extends StatelessWidget {
  const _TrackMealsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Track Meals', style: AppTextStyle.appbarHeading),
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
      body: BlocBuilder<TrackMealsBloc, TrackMealsState>(
        builder: (context, state) {
          if (state.status == TrackMealsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const _AddMealDialog(),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFF82C941)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      child: Text('+ Add', style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                _datePicker(context, state.date),
                SizedBox(height: 12.h),
                if (state.plan != null) _planHeader(state.plan!),
                if (state.plan != null) SizedBox(height: 12.h),
                if (state.plan != null) _macroCircles(state.plan!),
                SizedBox(height: 12.h),
                ...state.meals.map((m) => _MealTile(meal: m)).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _datePicker(BuildContext context, DateTime date) {
    String label() {
      final now = DateTime.now();
      if (date.year == now.year && date.month == now.month && date.day == now.day) return 'Today';
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }

    void changeBy(int days) {
      final newDate = date.add(Duration(days: days));
      context.read<TrackMealsBloc>().add(TrackMealsDateChanged(newDate));
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 0.5.w, color: const Color(0xFF82C941)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(onPressed: () => changeBy(-1), icon: const Icon(Icons.chevron_left, color: Colors.white)),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                Center(
                  child: Text(label(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          IconButton(onPressed: () => changeBy(1), icon: const Icon(Icons.chevron_right, color: Colors.white)),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Color(0xFF43A047).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFF82C941)),
                  ),
                  child: Center(
                    child: Text(m.timeLabel, style: GoogleFonts.poppins(color: Color(0xFF82C941), fontSize: 12.sp)),
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
                  _macroChip('P: ${m.proteinG}g', const Color(0xFF4A6CF7)),
                  _macroChip('C: ${m.carbsG}g', const Color(0xFF82C941)),
                  _macroChip('F: ${m.fatsG}g', const Color(0xFFFF6D00)),
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

  Widget _macroChip(String text, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp)),
    );
  }
}

class _AddMealDialog extends StatelessWidget {
  const _AddMealDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F0F15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.close, color: Colors.white, size: 20.sp),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(child: _inputField('Meal Name', 'Type...')),
                SizedBox(width: 16.w),
                Expanded(child: _inputField('Food Name', 'Type...')),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(child: _inputField('Amount', 'Type...')),
                SizedBox(width: 16.w),
                const Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _button('Cancel', const Color(0xFF1C222E), Colors.white, () => Navigator.pop(context)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _button('Add Meal', const Color(0xFF1A1A50), Colors.white, () {
                    Navigator.pop(context);
                  }, borderColor: const Color(0xFF3F3F9F)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint, {double width = 1.0}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
        SizedBox(height: 8.h),
        TextField(
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 13.sp),
            filled: true,
            fillColor: const Color(0xFF13131F),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: const Color(0xFF82C941)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _button(String text, Color bgColor, Color textColor, VoidCallback onTap, {Color? borderColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null ? Border.all(color: borderColor) : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(text, style: GoogleFonts.poppins(color: textColor, fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
