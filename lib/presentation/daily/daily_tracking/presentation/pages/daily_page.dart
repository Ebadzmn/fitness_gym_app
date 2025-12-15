import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitness_app/core/config/assets_path.dart';
import 'package:fitness_app/core/coreWidget/dropdown_yes_no_tile.dart';
import 'package:fitness_app/core/coreWidget/dropdown_tile.dart';
import 'package:fitness_app/domain/entities/daily_entities/daily_tracking_entity.dart';
import '../../../../../data/repositories/fake_daily_repository.dart';
import '../../../../../domain/usecases/daily/get_daily_initial_usecase.dart';
import '../../../../../domain/usecases/daily/save_daily_usecase.dart';
import 'bloc/daily_bloc.dart';
import 'bloc/daily_event.dart';
import 'bloc/daily_state.dart';

class DailyPage extends StatelessWidget {
  const DailyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeDailyRepository(),
      child: Builder(
        builder: (ctx) {
          final repo = RepositoryProvider.of<FakeDailyRepository>(ctx);
          return BlocProvider(
            create: (_) => DailyBloc(
              getInitial: GetDailyInitialUseCase(repo),
              saveDaily: SaveDailyUseCase(repo),
            )..add(const DailyInitRequested()),
            child: const _DailyView(),
          );
        },
      ),
    );
  }
}

class _DailyView extends StatelessWidget {
  const _DailyView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Daily Tracking'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0XFF1211E),
                child: SvgPicture.asset(AssetsPath.AbCalender),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<DailyBloc, DailyState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == DailyStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
          if (state.status == DailyStatus.saved) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Saved')));
          }
        },
        builder: (context, state) {
          if (state.status == DailyStatus.loading || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = state.data!;
          return Padding(
            padding: EdgeInsets.all(10.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  _dateTodayHeader(data.vital.dateLabel),
                  SizedBox(height: 12.h),
                  _weightCard(context, data.vital.weightText),
                  SizedBox(height: 12.h),
                  _sleepCard(
                    context,
                    data.sleep.durationText,
                    data.sleep.quality,
                  ),
                  SizedBox(height: 12.h),
                  _sickCard(context, data.isSick),
                  SizedBox(height: 12.h),
                  _waterCard(context, data.vital.waterText),
                  SizedBox(height: 12.h),
                  _energyWellBeingCard(context, data),
                  SizedBox(height: 12.h),
                  _trainingCard(context, data),
                  SizedBox(height: 12.h),
                  _activityTimeCard(context, data.vital.activityTimeText),
                  SizedBox(height: 20.h),
                  _nutritionCard(context, data),
                  SizedBox(height: 12.h),
                  _womenCard(context, data),
                  SizedBox(height: 12.h),
                  _pedCard(context, data),
                  SizedBox(height: 12.h),
                  _dailyNotesCard(context, data.notes),
                  SizedBox(height: 16.h),
                  _submitButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pillValue(int v) {
    return Container(
      height: 20.h,
      width: 30.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.green, width: 1.w),
      ),
      child: Center(
        child: Text(
          '$v',
          style: GoogleFonts.poppins(
            color: Colors.green,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _dateTodayHeader(String dateLabel) {
    return Container(
      height: 60.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Date:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  dateLabel,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 27.h,
              width: 74.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(89, 76, 154, 79),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white, width: 1.w),
              ),
              child: Center(
                child: Text(
                  'Today',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weightCard(BuildContext context, String initial) {
    final ctrl = TextEditingController(text: initial);
    return Container(
      height: 110.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.weight),
                SizedBox(width: 8.w),
                Text(
                  'Weight:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: ctrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: '65.2 (kg)',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => context.read<DailyBloc>().add(
                VitalTextChanged('weightText', v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sleepCard(BuildContext context, String durationText, double quality) {
    final ctrl = TextEditingController(text: durationText);
    return Container(
      height: 170.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.sleep),
                SizedBox(width: 8.w),
                Text(
                  'Sleep:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: ctrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: '08 : 45 (Minutes)',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) =>
                  context.read<DailyBloc>().add(SleepDurationChanged(v)),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  'Sleep Quality (1 - 10 )',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                _pillValue(quality.round()),
              ],
            ),
            FullWidthSlider(
              value: quality,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(SleepQualityChanged(v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sickCard(BuildContext context, bool isSick) {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.sick),
                SizedBox(width: 8.w),
                Text(
                  'Sick:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _circleOption(
              context,
              'Yes',
              isSick == true,
              () => context.read<DailyBloc>().add(const SickChanged(true)),
            ),
            SizedBox(height: 12.h),
            _circleOption(
              context,
              'No',
              isSick == false,
              () => context.read<DailyBloc>().add(const SickChanged(false)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleOption(
    BuildContext context,
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    final Color fillColor = selected ? Colors.green : Colors.grey;
    final Color borderColor = selected ? Colors.white : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fillColor,
              border: Border.all(color: borderColor, width: 2.w),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _waterCard(BuildContext context, String initial) {
    final ctrl = TextEditingController(text: initial);
    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.water),
                SizedBox(width: 8.w),
                Text(
                  'Water:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: ctrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: '1.2 (Lit)',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => context.read<DailyBloc>().add(
                VitalTextChanged('waterText', v),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'At least 2.5 liters recommended.',
              style: GoogleFonts.poppins(
                color: Colors.green,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _energyWellBeingCard(BuildContext context, DailyTrackingEntity data) {
    final bodyTempCtrl = TextEditingController(text: data.vital.bodyTempText);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Energy & Well-Being',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Energy Level (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.energy.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.energy,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(WellBeingChanged('energy', v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Stress Level (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.stress.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.stress,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(WellBeingChanged('stress', v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Muscle Soreness (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.muscleSoreness.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.muscleSoreness,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => context.read<DailyBloc>().add(
                WellBeingChanged('muscleSoreness', v),
              ),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mood (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.mood.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.mood,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(WellBeingChanged('mood', v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Motivation (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.wellBeing.motivation.round()),
              ],
            ),
            FullWidthSlider(
              value: data.wellBeing.motivation,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => context.read<DailyBloc>().add(
                WellBeingChanged('motivation', v),
              ),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            SizedBox(height: 12.h),
            Text(
              'Body Temperature',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: bodyTempCtrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Type..',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => context.read<DailyBloc>().add(
                VitalTextChanged('bodyTempText', v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trainingCard(BuildContext context, DailyTrackingEntity data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Training',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: 'Training Completed?',
              value: data.training.trainingCompleted,
              onChanged: (v) => context.read<DailyBloc>().add(
                TrainingToggleChanged('trainingCompleted', v),
              ),
            ),
            SizedBox(height: 12.h),
            _titledBox('Training Plan?'),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _checkboxTile(
                    context,
                    'Placeholder',
                    data.training.plans.contains('Placeholder'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _checkboxTile(
                    context,
                    'Push Fullbody',
                    data.training.plans.contains('Push Fullbody'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _checkboxTile(
                    context,
                    'Leg Day Advanced',
                    data.training.plans.contains('Leg Day Advanced'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _checkboxTile(
                    context,
                    'Training plan 1',
                    data.training.plans.contains('Training plan 1'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: 'Cardio Completed?',
              value: data.training.cardioCompleted,
              onChanged: (v) => context.read<DailyBloc>().add(
                TrainingToggleChanged('cardioCompleted', v),
              ),
            ),
            SizedBox(height: 12.h),
            _titledBox('Cardio Type ?'),
            SizedBox(height: 12.h),
            _cardioOptionsRow(context, data.training.cardioType),
            SizedBox(height: 12.h),
            _durationField(context, data.training.duration),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cardio Intensity (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.training.intensity.round()),
              ],
            ),
            FullWidthSlider(
              value: data.training.intensity,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => context.read<DailyBloc>().add(TrainingIntensityChanged(v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _titledBox(String title) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0XFF152032),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _checkboxTile(BuildContext context, String title, bool checked) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0XFF152032),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Checkbox(
            value: checked,
            onChanged: (v) => context.read<DailyBloc>().add(
              TrainingPlanToggled(title, v ?? false),
            ),
            side: const BorderSide(color: Colors.white54),
            checkColor: Colors.white,
            activeColor: Colors.green,
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioOption(
    BuildContext context,
    String label, {
    required bool selected,
    IconData? icon,
  }) {
    return InkWell(
      onTap: () =>
          context.read<DailyBloc>().add(TrainingCardioTypeChanged(label)),
      child: Row(
        children: [
          Container(
            height: 16.h,
            width: 16.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.green : Colors.transparent,
              border: Border.all(
                color: selected ? Colors.white : Colors.white54,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 18.sp),
            SizedBox(width: 6.w),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardioOptionsRow(BuildContext context, String selectedType) {
    final opts = <Map<String, dynamic>>[
      {'label': 'Walking', 'icon': Icons.directions_walk},
      {'label': 'Running', 'icon': Icons.directions_run},
      {'label': 'Cycling', 'icon': Icons.directions_bike},
      {'label': 'Swimming', 'icon': Icons.pool},
      {'label': 'Rowing', 'icon': Icons.rowing},
      {'label': 'Elliptical', 'icon': Icons.fitness_center},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final o in opts) ...[
            _radioOption(
              context,
              o['label'] as String,
              selected: selectedType == (o['label'] as String),
              icon: o['icon'] as IconData,
            ),
            SizedBox(width: 16.w),
          ],
        ],
      ),
    );
  }

  Widget _durationField(BuildContext context, String initial) {
    final ctrl = TextEditingController(text: initial);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF0A0A1F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Duration  (Minutes)',
          hintStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.grey, width: 1.w),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
        onChanged: (v) =>
            context.read<DailyBloc>().add(TrainingDurationChanged(v)),
      ),
    );
  }

  Widget _activityTimeCard(BuildContext context, String initial) {
    final ctrl = TextEditingController(text: initial);
    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(AssetsPath.Clock),
                SizedBox(width: 8.w),
                Text(
                  'Activity Time:',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: ctrl,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: '08:00',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: const Color(0XFF0A0A1F),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: Colors.grey, width: 1.w),
                ),
              ),
              onChanged: (v) => context.read<DailyBloc>().add(
                VitalTextChanged('activityTimeText', v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionCard(BuildContext context, DailyTrackingEntity data) {
    final caloriesCtrl = TextEditingController(
      text: data.nutrition.caloriesText,
    );
    final carbsCtrl = TextEditingController(text: data.nutrition.carbsText);
    final proteinCtrl = TextEditingController(text: data.nutrition.proteinText);
    final fatsCtrl = TextEditingController(text: data.nutrition.fatsText);
    final saltCtrl = TextEditingController(text: data.nutrition.saltText);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Nutrition',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calories',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        caloriesCtrl,
                        'Type..',
                        (v) => context.read<DailyBloc>().add(
                          NutritionTextChanged('caloriesText', v),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carbs',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        carbsCtrl,
                        'Type..',
                        (v) => context.read<DailyBloc>().add(
                          NutritionTextChanged('carbsText', v),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protein',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        proteinCtrl,
                        'Type..',
                        (v) => context.read<DailyBloc>().add(
                          NutritionTextChanged('proteinText', v),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fats',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _filledInput(
                        fatsCtrl,
                        'Type..',
                        (v) => context.read<DailyBloc>().add(
                          NutritionTextChanged('fatsText', v),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Hunger  (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.nutrition.hunger.round()),
              ],
            ),
            FullWidthSlider(
              value: data.nutrition.hunger,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => context.read<DailyBloc>().add(
                NutritionChanged('hunger', numberValue: v),
              ),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Digestion  (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.nutrition.digestion.round()),
              ],
            ),
            FullWidthSlider(
              value: data.nutrition.digestion,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) => context.read<DailyBloc>().add(
                NutritionChanged('digestion', numberValue: v),
              ),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            SizedBox(height: 12.h),
            Text(
              'Salt (g)',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _filledInput(
              saltCtrl,
              'Type..',
              (v) => context.read<DailyBloc>().add(
                NutritionTextChanged('saltText', v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filledInput(
    TextEditingController ctrl,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return TextFormField(
      controller: ctrl,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0XFF0A0A1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: onChanged,
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController ctrl,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        _filledInput(ctrl, 'Type..', onChanged),
      ],
    );
  }

  Widget _womenCard(BuildContext context, DailyTrackingEntity data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.woman_2_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Women',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownTile(
              title: 'Cycle Phase?',
              value: data.women.cyclePhase,
              options: const [
                'Follicular',
                'Ovulation',
                'Luteal',
                'Menstruation',
              ],
              onChanged: (v) =>
                  context.read<DailyBloc>().add(WomenCyclePhaseChanged(v)),
            ),
            SizedBox(height: 12.h),
            _titledBox('Cycle Day  ( ${data.women.cycleDayLabel} )'),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'PMS Symptoms (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.women.pms.round()),
              ],
            ),
            FullWidthSlider(
              value: data.women.pms,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(WomenPmsChanged(v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cramps  (1-10)',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _pillValue(data.women.cramps.round()),
              ],
            ),
            FullWidthSlider(
              value: data.women.cramps,
              min: 1,
              max: 10,
              divisions: 9,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(WomenCrampsChanged(v)),
              activeTrackColor: const Color(0xFF69B427),
              thumbColor: const Color(0xFF69B427),
              overlayColor: const Color(0xFF69B427).withOpacity(0.2),
            ),
            SizedBox(height: 12.h),
            DropdownMultiSelectTile(
              title: 'Symptoms',
              selected: data.women.symptoms,
              options: const [
                'Everything Fine',
                'Cramps',
                'Breast Tenderness',
                'Headache',
                'Acne',
                'Lower Back Pain',
                'Tiredness',
                'Cravings',
                'Sleepless',
                'Abdominal Pain',
                'Vaginal Itching',
                'Vaginal Dryness',
              ],
              onChanged: (s) =>
                  context.read<DailyBloc>().add(WomenSymptomsChanged(s)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pedCard(BuildContext context, DailyTrackingEntity data) {
    final sideEffectsCtrl = TextEditingController(
      text: data.pedHealth.sideEffects,
    );
    final systolicCtrl = TextEditingController(
      text: data.pedHealth.systolicText,
    );
    final diastolicCtrl = TextEditingController(
      text: data.pedHealth.diastolicText,
    );
    final restingHrCtrl = TextEditingController(
      text: data.pedHealth.restingHrText,
    );
    final glucoseCtrl = TextEditingController(text: data.pedHealth.glucoseText);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'PED',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            DropdownYesNoTile(
              title: 'Daily Dosage Taken',
              value: data.pedHealth.dosageTaken,
              onChanged: (v) =>
                  context.read<DailyBloc>().add(PedDosageChanged(v)),
            ),
            SizedBox(height: 12.h),
            Text(
              'Side Effects Notes',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            _textArea(
              sideEffectsCtrl,
              hint: 'Type...',
              onChanged: (v) =>
                  context.read<DailyBloc>().add(PedSideEffectsChanged(v)),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.bloodtype_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Blood Pressure (Everybody)',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _labeledField(
                    'Systolic',
                    systolicCtrl,
                    (v) => context.read<DailyBloc>().add(
                      PedBpChanged('systolicText', v),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _labeledField(
                    'Diastolic',
                    diastolicCtrl,
                    (v) => context.read<DailyBloc>().add(
                      PedBpChanged('diastolicText', v),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _labeledField(
              'Resting Heart Rate',
              restingHrCtrl,
              (v) => context.read<DailyBloc>().add(
                PedBpChanged('restingHrText', v),
              ),
            ),
            SizedBox(height: 12.h),
            _labeledField(
              'Blood Glucose',
              glucoseCtrl,
              (v) =>
                  context.read<DailyBloc>().add(PedBpChanged('glucoseText', v)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyNotesCard(BuildContext context, String notes) {
    final notesCtrl = TextEditingController(text: notes);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.note_alt_outlined, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'Daily Notes',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            _textArea(
              notesCtrl,
              hint: 'Type...',
              onChanged: (v) => context.read<DailyBloc>().add(DailyNotesChanged(v)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(20, 20, 255, 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onPressed: () => context.read<DailyBloc>().add(const SavePressed()),
        child: Text(
          'Submit',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _textArea(
    TextEditingController ctrl, {
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: 4,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0XFF0A0A1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: onChanged,
    );
  }
}
