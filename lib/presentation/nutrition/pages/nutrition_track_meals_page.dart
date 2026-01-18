import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/meal_food_item_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_plan_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_daily_tracking_entity.dart';
import 'package:fitness_app/domain/entities/nutrition_entities/nutrition_response_entity.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/track_meals/track_meals_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionTrackMealsPage extends StatelessWidget {
  const NutritionTrackMealsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final initialDate = DateTime.now();
    return BlocProvider(
      create: (_) =>
          sl<TrackMealsBloc>()..add(TrackMealsLoadRequested(initialDate)),
      child: const _TrackMealsView(),
    );
  }
}

class _TrackMealsView extends StatelessWidget {
  const _TrackMealsView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuTrackMealsTitle,
          style: AppTextStyle.appbarHeading,
        ),
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
          if (state.status == TrackMealsStatus.failure) {
            return Center(
              child: Text(
                localizations.trainingExerciseGenericError,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      final bloc = context.read<TrackMealsBloc>();
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => BlocProvider.value(
                          value: bloc,
                          child: _AddMealDialog(date: state.date),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFF82C941)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      child: Text(
                        '+ ${localizations.nutritionTrackAddMeal}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                _datePicker(context, state.date),
                SizedBox(height: 12.h),
                if (state.trackingData != null)
                  _planHeader(
                    context,
                    state.trackingData!.totals,
                    state.trackingData!.water,
                  ),
                if (state.trackingData != null) SizedBox(height: 12.h),
                if (state.trackingData != null)
                  _macroCircles(context, state.trackingData!.totals),
                SizedBox(height: 12.h),
                if (state.trackingData != null &&
                    state.trackingData!.data.isNotEmpty)
                  ...state.trackingData!.data.first.meals
                      .map((m) => _MealTile(meal: m))
                      .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _datePicker(BuildContext context, DateTime date) {
    final localizations = AppLocalizations.of(context)!;
    String label() {
      final now = DateTime.now();
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day)
        return localizations.dailyDateToday;
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
          IconButton(
            onPressed: () => changeBy(-1),
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Center(
                  child: Text(
                    label(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => changeBy(1),
            icon: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _planHeader(
    BuildContext context,
    NutritionTotalsEntity totals,
    int water,
  ) {
    final localizations = AppLocalizations.of(context)!;
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
                    localizations.nutritionTrackDailyGoalTitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    localizations.nutritionTrackDailyGoalSubtitle,
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
                      color: const Color(0xFF4A6CF7),
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${water}ml\n${localizations.dailyWaterLabel}',
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
                      color: const Color(0xFF82C941),
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${totals.totalCalories}\n${localizations.dailyNutritionCaloriesLabel}',
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

  Widget _macroCircles(BuildContext context, NutritionTotalsEntity totals) {
    final totalProtein = totals.totalProtein;
    final totalCarbs = totals.totalCarbs;
    final totalFats = totals.totalFats;

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
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
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
          macroItem(
            '${totalProtein.toInt()}g',
            AppLocalizations.of(context)!.dailyNutritionProteinLabel,
            const Color(0xFF2287DD),
            const Color(0xFF1B3043),
          ),
          macroItem(
            '${totalCarbs.toInt()}g',
            AppLocalizations.of(context)!.dailyNutritionCarbsLabel,
            const Color(0xFF43A047),
            const Color(0xFF224225),
          ),
          macroItem(
            '${totalFats.toInt()}g',
            AppLocalizations.of(context)!.dailyNutritionFatsLabel,
            const Color(0xFFFF6D00),
            const Color(0xFF42291A),
          ),
        ],
      ),
    );
  }
}

class _MealTile extends StatefulWidget {
  final TrackingMealEntity meal;
  const _MealTile({required this.meal});

  @override
  State<_MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<_MealTile> {
  bool _expanded =
      true; // Default expanded as per typical UX for active meal tracking

  @override
  Widget build(BuildContext context) {
    final m = widget.meal;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F15), // Dark background
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF2E2E5D)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                m.mealNumber, // changed from title
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
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
          SizedBox(height: 12.h),

          // Macros Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  '${m.totalCalories} kcal', // changed from calories
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF43A047), // Green color for calories
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 16.w),
                _macroBadge(
                  'P: ${m.totalProtein.toInt()}g', // changed from proteinG
                  const Color(0xFF1B3043),
                  const Color(0xFF2287DD),
                ),
                SizedBox(width: 8.w),
                _macroBadge(
                  'C: ${m.totalCarbs.toInt()}g', // changed from carbsG
                  const Color(0xFF224225),
                  const Color(0xFF43A047),
                ),
                SizedBox(width: 8.w),
                _macroBadge(
                  'F: ${m.totalFats.toInt()}g', // changed from fatsG
                  const Color(0xFF42291A),
                  const Color(0xFFFF6D00),
                ),
              ],
            ),
          ),

          // Expandable Content (Table)
          // Expandable Content
          _expandableContent(context, m),
        ],
      ),
    );
  }

  Widget _expandableContent(BuildContext context, TrackingMealEntity m) {
    final localizations = AppLocalizations.of(context)!;
    if (!_expanded) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      localizations.nutritionTrackFoodNameLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20.h,
                  color: const Color(0xFF2E2E5D),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      localizations.nutritionTrackFoodQuantityLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20.h,
                  color: const Color(0xFF2E2E5D),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      localizations.nutritionTrackTableActionLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (m.food.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  localizations.nutritionTrackNoItemsLogged,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),

          // Items list
          if (m.food.isNotEmpty)
            ...m.food.map(
              (item) => Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 8.w,
                          ),
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: const Color(0xFF2E2E5D),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            item.quantity,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: const Color(0xFF2E2E5D),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              if (item.id != null) {
                                context.read<TrackMealsBloc>().add(
                                  TrackMealsDeleteFoodItem(
                                    mealId: m.id,
                                    foodId: item.id!,
                                    date: context
                                        .read<TrackMealsBloc>()
                                        .state
                                        .date,
                                  ),
                                );
                              }
                            },
                            child: Icon(
                              Icons.delete_outline,
                              color: const Color(0xFFFDD835),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _macroBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _AddMealDialog extends StatefulWidget {
  final DateTime date;
  const _AddMealDialog({super.key, required this.date});
  @override
  State<_AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<_AddMealDialog> {
  final _mealCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final List<TextEditingController> _foodCtrls = [];
  final List<TextEditingController> _qtyCtrls = [];
  @override
  void initState() {
    super.initState();
    _addRow();
  }

  void _addRow() {
    _foodCtrls.add(TextEditingController());
    _qtyCtrls.add(TextEditingController());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
                Expanded(
                  child: _inputField(
                    localizations.nutritionTrackMealNameLabel,
                    localizations.nutritionTrackFoodNameHint,
                    controller: _mealCtrl,
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              children: [
                for (int i = 0; i < _foodCtrls.length; i++) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _inputField(
                          localizations.nutritionTrackFoodNameLabel,
                          localizations.nutritionTrackFoodNameHint,
                          controller: _foodCtrls[i],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _inputField(
                          localizations.nutritionTrackFoodQuantityLabel,
                          localizations.nutritionTrackFoodQuantityHint,
                          controller: _qtyCtrls[i],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                ],
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _addRow,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFF82C941)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 6.w),
                          Text(
                            localizations.nutritionTrackAddItem,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _button(
                    localizations.nutritionTrackCancel,
                    const Color(0xFF1C222E),
                    Colors.white,
                    () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _button(
                    localizations.nutritionTrackAddMeal,
                    const Color(0xFF1A1A50),
                    Colors.white,
                    () {
                      final mealName = _mealCtrl.text.trim();
                      final timeLabel = _timeCtrl.text.trim().isEmpty
                          ? 'Custom'
                          : _timeCtrl.text.trim();
                      final items = <MealFoodItemEntity>[];
                      for (int i = 0; i < _foodCtrls.length; i++) {
                        final food = _foodCtrls[i].text.trim();
                        final qty = _qtyCtrls[i].text.trim();
                        if (food.isEmpty || qty.isEmpty) continue;
                        items.add(
                          MealFoodItemEntity(name: food, quantity: qty),
                        );
                      }
                      if (mealName.isEmpty || items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            localizations.nutritionTrackValidationMealRequired,
                          ),
                        ));
                        return;
                      }
                      final meal = NutritionMealEntity(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        timeLabel: timeLabel,
                        title: mealName,
                        calories: 0,
                        proteinG: 0,
                        carbsG: 0,
                        fatsG: 0,
                        items: items,
                        trainingDay: localizations.nutritionTrackTrainingDayLabel,
                      );
                      context.read<TrackMealsBloc>().add(
                        TrackMealsAddMeal(widget.date, meal),
                      );
                      Navigator.pop(context);
                    },
                    borderColor: const Color(0xFF3F3F9F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    String hint, {
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.white38,
              fontSize: 13.sp,
            ),
            filled: true,
            fillColor: const Color(0xFF13131F),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
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

  Widget _button(
    String text,
    Color bgColor,
    Color textColor,
    VoidCallback onTap, {
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: borderColor != null
              ? Border.all(color: borderColor)
              : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
