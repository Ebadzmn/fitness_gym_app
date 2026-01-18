import 'dart:io';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class CheckingTab extends StatelessWidget {
  const CheckingTab({super.key});

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: const Color(0XFF101021),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF69B427), size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
              ),
              Icon(Icons.info_outline, color: Colors.white24, size: 18.sp),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF69B427).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: const Color(0xFF69B427),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Builder(
                      builder: (context) {
                        final localizations = AppLocalizations.of(context)!;
                        return Text(
                          localizations.checkInSinceLastBadge,
                          style: TextStyle(
                            color: const Color(0xFF69B427),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _ynRow(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Column(
          children: [
            _ynOption(localizations.commonYes, value == true, () => onChanged(true)),
            SizedBox(width: 16.w),
            _ynOption(localizations.commonNo, value == false, () => onChanged(false)),
          ],
        ),
      ],
    );
  }

  Widget _imageThumb(Widget child) {
    return Container(
      height: 70.h,
      width: 70.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3F),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(12.r), child: child),
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

  Widget _textArea(
    TextEditingController ctrl, {
    required String hint,
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context)!;
        final data = state.data;
        if (data == null) return const SizedBox.shrink();
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
            _summaryCard(
              icon: Icons.emoji_events_outlined,
              title: localizations.checkInCheckingCurrentWeightTitle,
              value: '${data.currentWeight} (kg)',
            ),
            _summaryCard(
              icon: Icons.percent,
              title: localizations.checkInCheckingAverageWeightTitle,
              value: '${data.averageWeight} (kg)',
            ),

            Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: const Color(0XFF101021),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        localizations.checkInCheckingBasicDataTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  _ynRow(
                    context,
                    localizations.checkInCheckingPicturesUploadedLabel,
                    data.uploads.picturesUploaded,
                    (v) => context.read<CheckInBloc>().add(
                      UploadsToggled('picturesUploaded', v),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  if (data.uploads.picturePaths.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: data.uploads.picturePaths.map((path) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: _imageThumb(
                              Image.file(
                                File(path),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white24,
                                      ),
                                    ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _imageThumb(Icon(Icons.image, color: Colors.white54)),
                          SizedBox(width: 8.w),
                          _imageThumb(Icon(Icons.image, color: Colors.white54)),
                          SizedBox(width: 8.w),
                          _imageThumb(Icon(Icons.image, color: Colors.white54)),
                          SizedBox(width: 8.w),
                          _imageThumb(Icon(Icons.image, color: Colors.white54)),
                        ],
                      ),
                    ),
                  SizedBox(height: 12.h),
                  _ynRow(
                    context,
                    localizations.checkInCheckingVideoUploadedLabel,
                    data.uploads.videoUploaded,
                    (v) => context.read<CheckInBloc>().add(
                      UploadsToggled('videoUploaded', v),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 140.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3F),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(child: Container()),
                        Center(
                          child: Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 12.w,
                          bottom: 12.h,
                          right: 12.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.uploads.videoPath != null &&
                                        data.uploads.videoPath!.isNotEmpty
                                    ? data.uploads.videoPath!.split('/').last
                                    : localizations.checkInCheckingVideoPlaceholderTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                data.uploads.videoPath != null &&
                                        data.uploads.videoPath!.isNotEmpty
                                    ? localizations.checkInCheckingVideoUploadedSubtitle
                                    : localizations.checkInCheckingVideoDefaultSubtitle,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: const Color(0XFF101021),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.checkInCheckingQuestionCountDescription,
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localizations.checkInQuestion1Title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27303B),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      'A1. ${data.answer1.isNotEmpty ? data.answer1 : localizations.commonNoAnswer}',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localizations.checkInQuestion2Title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27303B),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      'A2. ${data.answer2.isNotEmpty ? data.answer2 : localizations.commonNoAnswer}',
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
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
                    localizations.checkInWellBeingSectionTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _labelWithValue(
                    localizations.checkInWellBeingEnergyLabel,
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
                    localizations.checkInWellBeingStressLabel,
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
                    localizations.checkInWellBeingMoodLabel,
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
                    localizations.checkInWellBeingSleepLabel,
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
                    localizations.checkInNutritionSectionTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _labelWithValue(
                    localizations.checkInNutritionDietLevelLabel,
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
                    localizations.checkInNutritionDigestionLabel,
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
                    localizations.checkInNutritionChallengeTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _filledField(
                    challengeCtrl,
                    hint: localizations.commonTypeHint,
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
                    localizations.checkInTrainingSectionTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _labelWithValue(
                    localizations.checkInTrainingFeelStrengthLabel,
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
                  _labelWithValue(
                    localizations.checkInTrainingPumpsLabel,
                    data.training.pumps.round(),
                  ),
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
                    context,
                    localizations.checkInTrainingCompletedLabel,
                    data.training.trainingCompleted,
                    (v) => context.read<CheckInBloc>().add(
                      TrainingToggleChanged('trainingCompleted', v),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _ynRow(
                    context,
                    localizations.checkInTrainingCardioCompletedLabel,
                    data.training.cardioCompleted,
                    (v) => context.read<CheckInBloc>().add(
                      TrainingToggleChanged('cardioCompleted', v),
                    ),
                  ),

                  SizedBox(height: 8.h),
                  Text(
                    localizations.checkInTrainingFeedbackTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _textArea(
                    feedbackCtrl,
                    hint: localizations.commonTypeHint,
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
                    localizations.checkInAthleteNoteTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _textArea(
                    athleteNoteCtrl,
                    hint: localizations.commonTypeHint,
                    onChanged: (v) =>
                        context.read<CheckInBloc>().add(AthleteNoteChanged(v)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
