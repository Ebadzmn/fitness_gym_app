import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:fitness_app/presentation/daily/daily_tracking/presentation/pages/bloc/daily_event.dart'
    hide
        NutritionTextChanged,
        WellBeingChanged,
        DailyNotesChanged, // This might still be needed if DailyTracking still uses it, but CheckIn now uses AthleteNoteChanged
        TrainingToggleChanged;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionsTab extends StatelessWidget {
  const QuestionsTab({super.key});

  Widget _boxedLabel(String title) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _filledField(
    TextEditingController ctrl, {
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
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

  Widget _answerInput(
    TextEditingController ctrl, {
    String hint = 'Answer',
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0XFF101021),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
      onChanged: onChanged,
    );
  }

  Widget _labelWithValue(String label, int value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 20.h,
          width: 30.w,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFF69B427), width: 1.w),
          ),
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(
                color: const Color(0xFF69B427),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textArea(
    TextEditingController ctrl, {
    String hint = 'Type...',
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: 4,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
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

  Widget _ynOption(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 12.h,
            width: 12.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? const Color(0xFF69B427) : Colors.grey,
              border: Border.all(
                color: selected ? Colors.white : Colors.white54,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  Widget _ynRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Column(
          children: [
            _ynOption('Yes', value == true, () => onChanged(true)),
            SizedBox(width: 16.w),
            _ynOption('No', value == false, () => onChanged(false)),
          ],
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(
      builder: (context, state) {
        final data = state.data;
        if (data == null) return const SizedBox.shrink();
        final answerCtrl = TextEditingController(text: data.answer1);
        final answer2Ctrl = TextEditingController(text: data.answer2);
        final challengeCtrl = TextEditingController(
          text: data.nutrition.challenge,
        );
        final feedbackCtrl = TextEditingController(
          text: data.training.feedback,
        );
        final athleteNoteCtrl = TextEditingController(text: data.athleteNote);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q1 . What are you proud of? *',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            _answerInput(
              answerCtrl,
              hint: 'Answer',
              onChanged: (v) =>
                  context.read<CheckInBloc>().add(AnswerChanged(1, v)),
            ),
            SizedBox(height: 12.h),
            SizedBox(height: 12.h),
            Text(
              'Q2 . Calories per default quantity *',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            _answerInput(
              answer2Ctrl,
              hint: 'Type..',
              onChanged: (v) =>
                  context.read<CheckInBloc>().add(AnswerChanged(2, v)),
            ),
            SizedBox(height: 12.h),

            Container(
              decoration: BoxDecoration(
                color: const Color(0XFF101021),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Well-Being',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _labelWithValue(
                    'Energy Level (1-10)',
                    data.wellBeing.energy.round(),
                  ),
                  FullWidthSlider(
                    value: data.wellBeing.energy,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      WellBeingChanged('energy', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  _labelWithValue(
                    'Stress level (1-10)',
                    data.wellBeing.stress.round(),
                  ),
                  FullWidthSlider(
                    value: data.wellBeing.stress,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      WellBeingChanged('stress', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  _labelWithValue(
                    'Mood level (1-10)',
                    data.wellBeing.mood.round(),
                  ),
                  FullWidthSlider(
                    value: data.wellBeing.mood,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      WellBeingChanged('mood', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  _labelWithValue(
                    'Sleep quality (1-10)',
                    data.wellBeing.sleep.round(),
                  ),
                  FullWidthSlider(
                    value: data.wellBeing.sleep,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      WellBeingChanged('sleep', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0XFF101021),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutrition',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _labelWithValue(
                    'Diet Level  (1-10)',
                    data.nutrition.dietLevel.round(),
                  ),
                  FullWidthSlider(
                    value: data.nutrition.dietLevel,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      NutritionNumberChanged('dietLevel', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  _labelWithValue(
                    'Digestion  (1-10)',
                    data.nutrition.digestion.round(),
                  ),
                  FullWidthSlider(
                    value: data.nutrition.digestion,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      NutritionNumberChanged('digestion', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Challenge Diet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _filledField(
                    challengeCtrl,
                    hint: 'Type..',
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      NutritionTextChanged('challenge', v),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0XFF101021),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Training',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _labelWithValue(
                    'Feel Strength (1-10)',
                    data.training.feelStrength.round(),
                  ),
                  FullWidthSlider(
                    value: data.training.feelStrength,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      TrainingNumberChanged('feelStrength', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  _labelWithValue('Pumps  (1-10)', data.training.pumps.round()),
                  FullWidthSlider(
                    value: data.training.pumps,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      TrainingNumberChanged('pumps', v),
                    ),
                    overlayColor: const Color(0xFF69B427).withOpacity(0.2),
                  ),
                  SizedBox(height: 12.h),
                  _ynRow(
                    'Training Completed?',
                    data.training.trainingCompleted,
                    (v) => context.read<CheckInBloc>().add(
                      TrainingToggleChanged('trainingCompleted', v),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _ynRow(
                    'Cardio Completed?',
                    data.training.cardioCompleted,
                    (v) => context.read<CheckInBloc>().add(
                      TrainingToggleChanged('cardioCompleted', v),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Feedback Training',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _filledField(
                    feedbackCtrl,
                    hint: 'Type..',
                    onChanged: (v) => context.read<CheckInBloc>().add(
                      TrainingTextChanged('feedback', v),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0XFF101021),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Athlete Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _textArea(
                    athleteNoteCtrl,
                    hint: 'Type...',
                    onChanged: (v) =>
                        context.read<CheckInBloc>().add(AthleteNoteChanged(v)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.read<CheckInBloc>().add(
                      const CheckInStepSet(1),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF101021),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: Color(0xFF2E2E5D)),
                      ),
                    ),
                    child: Text(
                      "Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.read<CheckInBloc>().add(
                      const CheckInStepSet(3),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1448),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: Color(0xFF2E2E5D)),
                      ),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}
