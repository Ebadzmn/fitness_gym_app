import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';

class CheckingTab extends StatelessWidget {
  const CheckingTab({super.key});

  Widget _summaryCard({required IconData icon, required String title, required String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.white10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: const Color(0xFF82C941), size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(child: Text(title, style: TextStyle(color: Colors.white70, fontSize: 14.sp))),
          Icon(Icons.info_outline, color: Colors.white24, size: 18.sp),
        ]),
        SizedBox(height: 10.h),
        Row(children: [
          Expanded(child: Text(value, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(color: const Color(0xFF82C941).withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
            child: Row(children: [
              Icon(Icons.check_circle_outline, color: const Color(0xFF82C941), size: 16.sp),
              SizedBox(width: 4.w),
              Text('Check-in since last', style: TextStyle(color: const Color(0xFF82C941), fontSize: 10.sp, fontWeight: FontWeight.w500)),
            ]),
          ),
        ]),
      ]),
    );
  }

  Widget _ynOption(String text, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        Container(
          height: 12.h,
          width: 12.h,
          decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? Colors.green : Colors.grey, border: Border.all(color: selected ? Colors.white : Colors.white54)),
        ),
        SizedBox(width: 8.w),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
      ]),
    );
  }

  Widget _ynRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
      SizedBox(height: 8.h),
      Column(children: [
        _ynOption('Yes', value == true, () => onChanged(true)),
        SizedBox(width: 16.w),
        _ynOption('No', value == false, () => onChanged(false)),
      ]),
    ]);
  }

  Widget _imageThumb(Widget child) {
    return Container(
      height: 70.h,
      width: 70.h,
      decoration: BoxDecoration(color: const Color(0xFF2A2A3F), borderRadius: BorderRadius.circular(12.r)),
      child: ClipRRect(borderRadius: BorderRadius.circular(12.r), child: child),
    );
  }

  Widget _labelWithValue(String label, int value) {
    return Row(children: [
      Expanded(child: Text(label, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500))),
      Container(
        height: 20.h,
        width: 30.w,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: Colors.green, width: 1.w)),
        child: Center(child: Text('$value', style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.w500))),
      ),
    ]);
  }

  Widget _filledField(TextEditingController ctrl, {required String hint, required ValueChanged<String> onChanged}) {
    return TextFormField(
      controller: ctrl,
      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0XFF0A0A1F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: onChanged,
    );
  }

  Widget _textArea(TextEditingController ctrl, {String hint = 'Type...', ValueChanged<String>? onChanged}) {
    return TextFormField(
      controller: ctrl,
      maxLines: 4,
      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0XFF0A0A1F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      onChanged: onChanged,
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(builder: (context, state) {
      final data = state.data;
      if (data == null) return const SizedBox.shrink();
      final challengeCtrl = TextEditingController(text: data.nutrition.challenge);
      final feedbackCtrl = TextEditingController(text: data.training.feedback);
      final dailyNotesCtrl = TextEditingController(text: data.dailyNotes);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _summaryCard(icon: Icons.emoji_events_outlined, title: 'Weight Class', value: '80.2 (kg)'),
        _summaryCard(icon: Icons.percent, title: 'Average Weight in %', value: '80.2 (%)'),

      Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        child: Column(children: [
          Row(children: [
            Text('Basic Data', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          ]),
          SizedBox(height: 12.h),
          _ynRow('Pictures uploaded?', data.uploads.picturesUploaded, (v) => context.read<CheckInBloc>().add(UploadsToggled('picturesUploaded', v))),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _imageThumb(Icon(Icons.image, color: Colors.white54)),
              SizedBox(width: 8.w),
              _imageThumb(Icon(Icons.image, color: Colors.white54)),
              SizedBox(width: 8.w),
              _imageThumb(Icon(Icons.image, color: Colors.white54)),
              SizedBox(width: 8.w),
              _imageThumb(Icon(Icons.image, color: Colors.white54)),
            ]),
          ),
          SizedBox(height: 12.h),
          _ynRow('Video uploaded?', data.uploads.videoUploaded, (v) => context.read<CheckInBloc>().add(UploadsToggled('videoUploaded', v))),
          SizedBox(height: 12.h),
          Container(
            height: 140.h,
            decoration: BoxDecoration(color: const Color(0xFF2A2A3F), borderRadius: BorderRadius.circular(16.r), border: Border.all(color: Colors.white10)),
            child: Stack(children: [
              Positioned.fill(child: Container()),
              Center(
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 28.sp),
                ),
              ),
              Positioned(
                left: 12.w,
                bottom: 12.h,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Muscular Workout', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  Text('Upper Body Low', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                ]),
              ),
            ]),
          ),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Select how many questions you have answered (You must answer at least 7 questions)', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
          SizedBox(height: 12.h),
          Text('Q1 . What are you proud of?', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(color: const Color(0xFF27303B), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.white10)),
            child: Text('A1. I\'m proud of my hard work and perseverance.', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          ),
          SizedBox(height: 12.h),
          Text('Q2 . What went well last week? *', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(color: const Color(0xFF27303B), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.white10)),
            child: Text('A2. I completed all my tasks on time.', style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          ),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Well-Being', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Energy Level (1-10)', data.wellBeing.energy.round()),
          FullWidthSlider(value: data.wellBeing.energy, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(WellBeingChanged('energy', v)), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Stress level (1-10)', data.wellBeing.stress.round()),
          FullWidthSlider(value: data.wellBeing.stress, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(WellBeingChanged('stress', v)), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Mood level (1-10)', data.wellBeing.mood.round()),
          FullWidthSlider(value: data.wellBeing.mood, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(WellBeingChanged('mood', v)), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Sleep quality (1-10)', data.wellBeing.sleep.round()),
          FullWidthSlider(value: data.wellBeing.sleep, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(WellBeingChanged('sleep', v)), overlayColor: Colors.green.withOpacity(0.2)),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nutrition', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Diet Level  (1-10)', data.nutrition.dietLevel.round()),
          FullWidthSlider(value: data.nutrition.dietLevel, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(NutritionNumberChanged('dietLevel', v)), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Digestion  (1-10)', data.nutrition.digestion.round()),
          FullWidthSlider(value: data.nutrition.digestion, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(NutritionNumberChanged('digestion', v)), overlayColor: Colors.green.withOpacity(0.2)),
          SizedBox(height: 12.h),
          Text('Challenge Diet', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          _filledField(challengeCtrl, hint: 'Type..', onChanged: (v) => context.read<CheckInBloc>().add(NutritionTextChanged('challenge', v))),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Training', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Feel Strength (1-10)', data.training.feelStrength.round()),
          FullWidthSlider(value: data.training.feelStrength, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(TrainingNumberChanged('feelStrength', v)), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Pumps  (1-10)', data.training.pumps.round()),
          FullWidthSlider(value: data.training.pumps, min: 1, max: 10, divisions: 9, onChanged: (v) => context.read<CheckInBloc>().add(TrainingNumberChanged('pumps', v)), overlayColor: Colors.green.withOpacity(0.2)),
          SizedBox(height: 12.h),
          _ynRow('Training Completed?', data.training.trainingCompleted, (v) => context.read<CheckInBloc>().add(TrainingToggleChanged('trainingCompleted', v))),
          SizedBox(height: 12.h),
          _ynRow('Cardio Completed?', data.training.cardioCompleted, (v) => context.read<CheckInBloc>().add(TrainingToggleChanged('cardioCompleted', v))),
          SizedBox(height: 12.h),
          Text('Feedback Training', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          _filledField(feedbackCtrl, hint: 'Type..', onChanged: (v) => context.read<CheckInBloc>().add(TrainingTextChanged('feedback', v))),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Daily Notes', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          _textArea(dailyNotesCtrl, hint: 'Type...', onChanged: (v) => context.read<CheckInBloc>().add(DailyNotesChanged(v))),
        ]),
      ),
    ]);
    });
  }
}
