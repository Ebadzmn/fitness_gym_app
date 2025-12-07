import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';

class QuestionsTab extends StatefulWidget {
  const QuestionsTab({super.key});

  @override
  State<QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<QuestionsTab> {
  final _answerCtrl = TextEditingController();
  final _answer2Ctrl = TextEditingController();
  final _challengeCtrl = TextEditingController();
  final _feedbackCtrl = TextEditingController();
  final _dailyNotesCtrl = TextEditingController();

  double _energy = 6;
  double _stress = 6;
  double _mood = 6;
  double _sleep = 6;

  double _dietLevel = 6;
  double _digestion = 6;
  double _feelStrength = 6;
  double _pumps = 6;
  bool _trainingCompleted = true;
  bool _cardioCompleted = true;

  @override
  void dispose() {
    _answerCtrl.dispose();
    _answer2Ctrl.dispose();
    _challengeCtrl.dispose();
    _feedbackCtrl.dispose();
    _dailyNotesCtrl.dispose();
    super.dispose();
  }

  Widget _boxedLabel(String title) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(color: const Color(0XFF1C1C2E), borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Text(title, style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.w500)),
    );
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

  Widget _answerInput(TextEditingController ctrl, {String hint = 'Answer'}) {
    return TextFormField(
      controller: ctrl,
      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0XFF1C1C2E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: Colors.grey, width: 1.w)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
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
      Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
      SizedBox(height: 6.h),
      Column(children: [
        _ynOption('Yes', value == true, () => onChanged(true)),
        SizedBox(width: 16.w),
        _ynOption('No', value == false, () => onChanged(false)),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Q1 . What are you proud of? *', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
      SizedBox(height: 12.h),
      _answerInput(_answerCtrl, hint: 'Answer'),
      SizedBox(height: 12.h),
      SizedBox(height: 12.h),
      Text('Q2 . Calories per default quantity *', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
      SizedBox(height: 12.h),
      _answerInput(_answer2Ctrl, hint: 'Type..'),
      SizedBox(height: 12.h),

      Container(
        decoration: BoxDecoration(color: const Color(0XFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Well-Being', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Energy Level (1-10)', _energy.round()),
          FullWidthSlider(value: _energy, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _energy = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Stress level (1-10)', _stress.round()),
          FullWidthSlider(value: _stress, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _stress = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Mood level (1-10)', _mood.round()),
          FullWidthSlider(value: _mood, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _mood = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Sleep quality (1-10)', _sleep.round()),
          FullWidthSlider(value: _sleep, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _sleep = v), overlayColor: Colors.green.withOpacity(0.2)),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0XFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(12.sp),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Nutrition', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 12.h),
          _labelWithValue('Diet Level  (1-10)', _dietLevel.round()),
          FullWidthSlider(value: _dietLevel, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _dietLevel = v), overlayColor: Colors.green.withOpacity(0.2)),
          _labelWithValue('Digestion  (1-10)', _digestion.round()),
          FullWidthSlider(value: _digestion, min: 1, max: 10, divisions: 9, onChanged: (v) => setState(() => _digestion = v), overlayColor: Colors.green.withOpacity(0.2)),
          SizedBox(height: 12.h),
          Text('Challenge Diet', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 8.h),
          _filledField(_challengeCtrl, hint: 'Type..'),
        ]),
      ),

      SizedBox(height: 12.h),
      Container(
        decoration: BoxDecoration(color: const Color(0XFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
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
        decoration: BoxDecoration(color: const Color(0XFF1C1C2E), borderRadius: BorderRadius.circular(12.r)),
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

