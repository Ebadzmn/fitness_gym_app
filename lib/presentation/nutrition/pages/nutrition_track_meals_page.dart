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
import 'package:fitness_app/features/nutrition/domain/usecases/save_track_meal_usecase.dart';

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
      child: Builder(
        builder: (ctx) {
          final mealsRepo = RepositoryProvider.of<FakeTrackMealsRepository>(
            ctx,
          );
          final planRepo = RepositoryProvider.of<FakeNutritionPlanRepository>(
            ctx,
          );
          return BlocProvider(
            create: (_) => TrackMealsBloc(
              initialDate: initialDate,
              getMeals: GetTrackMealsUseCase(mealsRepo),
              getPlan: GetNutritionPlanUseCase(planRepo),
              saveMeal: SaveTrackMealUseCase(mealsRepo),
            )..add(TrackMealsLoadRequested(initialDate)),
            child: const _TrackMealsView(),
          );
        },
      ),
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
                        '+ Add',
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
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day)
        return 'Today';
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
                      color: const Color(0xFF4A6CF7),
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${plan.waterLiters}L\nWater',
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
                      '${plan.calories}\nCalories',
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
            '${plan.proteinG}g',
            'Protein',
            const Color(0xFF2287DD),
            const Color(0xFF1B3043),
          ),
          macroItem(
            '${plan.carbsG}g',
            'Carbs',
            const Color(0xFF43A047),
            const Color(0xFF224225),
          ),
          macroItem(
            '${plan.fatsG}g',
            'Fats',
            const Color(0xFFFF6D00),
            const Color(0xFF42291A),
          ),
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
                m.title,
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
          Row(
            children: [
              Text(
                '${m.calories} kcal',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF43A047), // Green color for calories
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 16.w),
              _macroBadge(
                'P: ${m.proteinG}g',
                const Color(0xFF1B3043),
                const Color(0xFF2287DD),
              ),
              SizedBox(width: 8.w),
              _macroBadge(
                'C: ${m.carbsG}g',
                const Color(0xFF224225),
                const Color(0xFF43A047),
              ),
              SizedBox(width: 8.w),
              _macroBadge(
                'F: ${m.fatsG}g',
                const Color(0xFF42291A),
                const Color(0xFFFF6D00),
              ),
            ],
          ),

          // Expandable Content (Table)
          if (_expanded) ...[
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF2E2E5D)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  // Table Header
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                            child: Text(
                              'Name',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFF2E2E5D),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Text(
                                'Quantity',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color(0xFF2E2E5D),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Text(
                                'Action',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFF2E2E5D),
                  ),
                  // Table Data
                  ...m.items.map((item) {
                    // Parsing logic
                    String name = item;
                    String quantity = '';
                    if (item.contains('(') && item.contains(')')) {
                      int startIndex = item.lastIndexOf('(');
                      int endIndex = item.lastIndexOf(')');
                      name = item.substring(0, startIndex).trim();
                      quantity = item
                          .substring(startIndex + 1, endIndex)
                          .trim();
                    }

                    return Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.h,
                                    horizontal: 16.w,
                                  ),
                                  child: Text(
                                    name,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Color(0xFF2E2E5D),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    quantity,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Color(0xFF2E2E5D),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      // TODO: Implement delete action
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: const Color(0xFFFDD835),
                                      size: 20.sp,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (item != m.items.last)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFF2E2E5D),
                          ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
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
        // border: Border.all(color: textColor.withOpacity(0.3)), // Optional border
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
                Expanded(child: _inputField('Meal Name', 'Type...', controller: _mealCtrl)),
                SizedBox(width: 16.w),
                Expanded(child: _inputField('Time (e.g. 13:00)', 'HH:mm', controller: _timeCtrl)),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              children: [
                for (int i = 0; i < _foodCtrls.length; i++) ...[
                  Row(
                    children: [
                      Expanded(child: _inputField('Food Name', 'Type...', controller: _foodCtrls[i])),
                      SizedBox(width: 16.w),
                      Expanded(child: _inputField('Quantity', 'e.g. 200g', controller: _qtyCtrls[i])),
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
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 6.w),
                          Text(
                            'Add item',
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
                    'Cancel',
                    const Color(0xFF1C222E),
                    Colors.white,
                    () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _button(
                    'Add Meal',
                    const Color(0xFF1A1A50),
                    Colors.white,
                    () {
                      final mealName = _mealCtrl.text.trim();
                      final timeLabel = _timeCtrl.text.trim().isEmpty ? 'Custom' : _timeCtrl.text.trim();
                      final items = <String>[];
                      for (int i = 0; i < _foodCtrls.length; i++) {
                        final food = _foodCtrls[i].text.trim();
                        final qty = _qtyCtrls[i].text.trim();
                        if (food.isEmpty || qty.isEmpty) continue;
                        items.add('$food ($qty)');
                      }
                      if (mealName.isEmpty || items.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meal name and at least one item required')),
                        );
                        return;
                      }
                      final meal = NutritionMealEntity(
                        timeLabel: timeLabel,
                        title: mealName,
                        calories: 0,
                        proteinG: 0,
                        carbsG: 0,
                        fatsG: 0,
                        items: items,
                      );
                      context.read<TrackMealsBloc>().add(TrackMealsAddMeal(widget.date, meal));
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

  Widget _inputField(String label, String hint, {TextEditingController? controller}) {
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
