import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/features/nutrition/data/repositories/fake_nutrition_repository.dart';
import 'package:fitness_app/features/nutrition/domain/usecases/get_nutrition_initial_usecase.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_bloc/nutrition_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_bloc/nutrition_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_bloc/nutrition_state.dart';

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeNutritionRepository(),
      child: Builder(builder: (ctx) {
        final repo = RepositoryProvider.of<FakeNutritionRepository>(ctx);
        return BlocProvider(
          create: (_) => NutritionBloc(
            getInitial: GetNutritionInitialUseCase(repo),
          )..add(const NutritionInitRequested()),
          child: const _NutritionView(),
        );
      }),
    );
  }
}

class _NutritionView extends StatelessWidget {
  const _NutritionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Nutrition', style: AppTextStyle.appbarHeading),
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
      body: BlocBuilder<NutritionBloc, NutritionState>(
        builder: (context, state) {
          if (state.status == NutritionStatus.loading || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = state.data!;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                _macrosCard(
                  caloriesText: '${data.caloriesConsumed} / ${data.caloriesGoal} kcal',
                  proteinLabel: 'Protein',
                  proteinValueText: '${data.proteinConsumed}g/ ${data.proteinGoal}g',
                  proteinProgress: data.proteinConsumed / data.proteinGoal,
                  carbsLabel: 'Carbs',
                  carbsValueText: '${data.carbsConsumed}g/ ${data.carbsGoal}g',
                  carbsProgress: data.carbsConsumed / data.carbsGoal,
                  fatLabel: 'Fat',
                  fatValueText: '${data.fatConsumed}g/ ${data.fatGoal}g',
                  fatProgress: data.fatConsumed / data.fatGoal,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.restaurant_menu,
                        iconColor: const Color(0xFF82C941),
                        title: 'Food Items',
                        subtitle: 'Database',
                        borderColor: const Color(0xFF294328),
                        onTap: () => context.push(AppRoutes.nutritionFoodItemsPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.calendar_month_outlined,
                        iconColor: const Color(0xFF4A6CF7),
                        title: 'NUTRITION PLAN',
                        subtitle: 'Wekly Overview',
                        borderColor: const Color(0xFF1D89E47A).withOpacity(0.4),
                        onTap: () => context.push(AppRoutes.nutritionPlanPage),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.add_circle_outline,
                        iconColor: const Color(0xFFFF6D00),
                        title: 'TRACK MEALS',
                        subtitle: 'To Record',
                        borderColor: const Color(0xFFFF6D00).withOpacity(0.4),
                        onTap: () => context.push(AppRoutes.nutritionTrackMealsPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.stacked_line_chart,
                        iconColor: const Color(0xFFFF6D00),
                        title: 'STATISTICS',
                        subtitle: 'View History',
                        borderColor: const Color(0xFFFC9502).withOpacity(0.4),
                        onTap: () => context.push(AppRoutes.nutritionStatisticsPage),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _menuTile(
                        icon: Icons.medication_liquid,
                        iconColor: const Color(0xFF4A6CF7),
                        title: 'SUPPLEMENTS Plan',
                        subtitle: '',
                        borderColor: const Color(0xFFFC9502).withOpacity(0.4),
                        onTap: () => context.push(AppRoutes.nutritionSupplementPage),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _menuTile(
                        icon: Icons.science_outlined,
                        iconColor: const Color(0xFFFF6D00),
                        title: "PED's",
                        subtitle: 'Plan',
                        borderColor: const Color(0xFFFC9502).withOpacity(0.4),
                        onTap: () => context.push(AppRoutes.nutritionPEDsPage),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _macrosCard({
    required String caloriesText,
    required String proteinLabel,
    required String proteinValueText,
    required double proteinProgress,
    required String carbsLabel,
    required String carbsValueText,
    required double carbsProgress,
    required String fatLabel,
    required String fatValueText,
    required double fatProgress,
  }) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF212021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF838383)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Macros",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                caloriesText,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF82C941),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _macroRow(label: proteinLabel, valueText: proteinValueText, color: const Color(0xFF4A6CF7), progress: proteinProgress),
          SizedBox(height: 8.h),
          _macroRow(label: carbsLabel, valueText: carbsValueText, color: const Color(0xFF82C941), progress: carbsProgress),
          SizedBox(height: 8.h),
          _macroRow(label: fatLabel, valueText: fatValueText, color: const Color(0xFFFF6D00), progress: fatProgress),
        ],
      ),
    );
  }

  Widget _macroRow({
    required String label,
    required String valueText,
    required Color color,
    required double progress,
  }) {
    progress = progress.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp)),
            Text(valueText, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp)),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            minHeight: 6.h,
            value: progress,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    required Color borderColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C2E),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
        ),
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28.sp),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
