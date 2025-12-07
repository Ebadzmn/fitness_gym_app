import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';

class CheckingTab extends StatefulWidget {
  const CheckingTab({super.key});

  @override
  State<CheckingTab> createState() => _CheckingTabState();
}

class _CheckingTabState extends State<CheckingTab> {
  bool _picturesUploaded = true;
  bool _videoUploaded = true;
  double _wbEnergy = 6;
  double _wbStress = 6;
  double _wbMood = 6;
  double _wbSleep = 6;
  double _nutDiet = 6;
  double _nutDigestion = 6;
  final TextEditingController _challengeDietCtrl = TextEditingController();
  double _feelStrength = 6;
  double _pumps = 6;
  bool _trainingCompleted = true;
  bool _cardioCompleted = true;
  final TextEditingController _feedbackCtrl = TextEditingController();
  final TextEditingController _dailyNotesCtrl = TextEditingController();

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

  Widget _filledField(TextEditingController ctrl, {required String hint}) {
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
    );
  }

  Widget _textArea(TextEditingController ctrl, {String hint = 'Type...'}) {
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
    );
  }

  @override
  void dispose() {
    _challengeDietCtrl.dispose();
    _feedbackCtrl.dispose();
    _dailyNotesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          _ynRow('Pictures uploaded?', _picturesUploaded, (v) => setState(() => _picturesUploaded = v)),
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
          _ynRow('Video uploaded?', _videoUploaded, (v) => setState(() => _videoUploaded = v)),
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
          _labelWithValue('Energy Level (1-10)', _wbEnergy.round()),
          FullWidthSlider(value: _wbEnergy, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _wbEnergy = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Stress level (1-10)', _wbStress.round()),
          FullWidthSlider(value: _wbStress, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _wbStress = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Mood level (1-10)', _wbMood.round()),
          FullWidthSlider(value: _wbMood, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _wbMood = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Sleep quality (1-10)', _wbSleep.round()),
          FullWidthSlider(value: _wbSleep, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _wbSleep = v), overlayColor: Colors.green.withOpacity(0.2)),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nutrition', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Diet Level  (1-10)', _nutDiet.round()),
          FullWidthSlider(value: _nutDiet, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _nutDiet = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Digestion  (1-10)', _nutDigestion.round()),
          FullWidthSlider(value: _nutDigestion, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _nutDigestion = v), overlayColor: Colors.green.withOpacity(0.2)),
          SizedBox(height: 12.h),
          Text('Challenge Diet', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          _filledField(_challengeDietCtrl, hint: 'Type..'),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Training', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Feel Strength (1-10)', _feelStrength.round()),
          FullWidthSlider(value: _feelStrength, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _feelStrength = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Pumps  (1-10)', _pumps.round()),
          FullWidthSlider(value: _pumps, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _pumps = v), overlayColor: Colors.green.withOpacity(0.2)),
          SizedBox(height: 12.h),
          _ynRow('Training Completed?', _trainingCompleted, (v) => setState(() => _trainingCompleted = v)),
          SizedBox(height: 12.h),
          _ynRow('Cardio Completed?', _cardioCompleted, (v) => setState(() => _cardioCompleted = v)),
          SizedBox(height: 12.h),
          Text('Feedback Training', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          _filledField(_feedbackCtrl, hint: 'Type..'),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0xFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Daily Notes', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          _textArea(_dailyNotesCtrl, hint: 'Type...'),
        ]),
      ),
    ]);
  }
}

