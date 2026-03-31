import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';
import 'package:fitness_app/core/apiUrls/api_urls.dart';
import 'package:fitness_app/core/network/api_client.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CheckInQuestion {
  final String question;
  final bool isScale;
  final bool isFromApi;
  final RxBool status;
  final RxString answer;
  final RxDouble scaleValue;
  final TextEditingController? controller;

  CheckInQuestion({
    required this.question,
    this.isScale = false,
    this.isFromApi = false,
    bool status = false,
    String answer = '',
    double scaleValue = 1,
  }) : status = status.obs,
       answer = (isScale ? scaleValue.round().toString() : answer).obs,
       scaleValue = scaleValue.clamp(1.0, 10.0).toDouble().obs,
       controller = isScale ? null : TextEditingController(text: answer) {
    if (isScale) {
      this.status.value = true;
    } else {
      this.status.value = this.answer.value.trim().isNotEmpty;
    }
  }

  factory CheckInQuestion.fromMap(Map<String, dynamic> map) {
    String str(Object? v) => (v ?? '').toString();
    bool boolVal(Object? v) {
      if (v is bool) return v;
      final s = v?.toString().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }

    final q = str(map['question']).trim().isNotEmpty
        ? str(map['question']).trim()
        : str(map['Question']).trim();

    return CheckInQuestion(
      question: q.trim(),
      isScale: false,
      isFromApi: true,
      status: boolVal(map['status']),
      answer: '',
    );
  }
}

class CheckInQuestionsController extends GetxController {
  final ApiClient apiClient;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxList<CheckInQuestion> questionList = <CheckInQuestion>[].obs;

  CheckInQuestionsController({required this.apiClient});

  @override
  void onInit() {
    super.onInit();
    _loadStaticQuestions();
    fetchApiQuestions();
  }

  void _loadStaticQuestions() {
    questionList.assignAll(
      <CheckInQuestion>[
        CheckInQuestion(question: 'What went well this week?'),
        CheckInQuestion(
          question: 'Energy Level (1-10)',
          isScale: true,
          scaleValue: 1,
        ),
        CheckInQuestion(question: 'Mood (1-10)', isScale: true, scaleValue: 1),
        CheckInQuestion(
          question: 'Hunger (1-10)',
          isScale: true,
          scaleValue: 1,
        ),
        CheckInQuestion(
          question: 'Nutrition Plan adherence (1-10)',
          isScale: true,
          scaleValue: 1,
        ),
        CheckInQuestion(
          question: 'Stress Level (1-10)',
          isScale: true,
          scaleValue: 1,
        ),
        CheckInQuestion(question: 'Challenges?'),
        CheckInQuestion(
          question:
              'What do we need to change, so you can achieve your goals EVEN better?',
        ),
        CheckInQuestion(question: 'Something you want to tell me?'),
      ],
    );
  }

  Future<void> fetchApiQuestions() async {
    isLoading.value = true;
    try {
      final response = await apiClient.get(ApiUrls.checkInQuestions);
      final apiQuestions = _parseQuestions(response.data);
      if (apiQuestions.isNotEmpty) {
        questionList.insertAll(0, apiQuestions);
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  List<CheckInQuestion> _parseQuestions(dynamic raw) {
    dynamic payload = raw;
    if (payload is Map<String, dynamic>) {
      payload = payload['data'];
    }
    if (payload is! List) return const <CheckInQuestion>[];

    final list = <CheckInQuestion>[];
    for (final item in payload) {
      if (item is Map<String, dynamic>) {
        final q = CheckInQuestion.fromMap(item);
        if (q.question.trim().isNotEmpty) {
          list.add(q);
        }
      }
    }
    return list;
  }

  void setAnswer(CheckInQuestion q, String value) {
    if (q.isScale) return;
    q.answer.value = value;
    q.status.value = value.trim().isNotEmpty;
  }

  void setScale(CheckInQuestion q, double value) {
    if (!q.isScale) return;
    final v = value.clamp(1.0, 10.0).toDouble();
    q.scaleValue.value = v;
    q.answer.value = v.round().toString();
    q.status.value = true;
  }

  bool hasAnyEmptyAnswer() {
    for (final q in questionList) {
      if (!q.isScale && q.answer.value.trim().isEmpty) return true;
    }
    return false;
  }

  List<Map<String, String>> buildAnswersPayload() {
    return questionList
        .map(
          (q) => <String, String>{
            'question': q.question,
            'answer': q.answer.value,
          },
        )
        .toList();
  }

  @override
  void onClose() {
    for (final q in questionList) {
      q.controller?.dispose();
    }
    super.onClose();
  }
}

class QuestionsTab extends StatefulWidget {
  const QuestionsTab({super.key});

  @override
  State<QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<QuestionsTab> {
  bool _showValidationErrors = false;
  late final CheckInQuestionsController _checkInQuestionsController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<CheckInQuestionsController>()) {
      _checkInQuestionsController = Get.find<CheckInQuestionsController>();
    } else {
      _checkInQuestionsController = Get.put(
        CheckInQuestionsController(apiClient: sl<ApiClient>()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _checkInQuestionsSection(AppLocalizations localizations) {
    return Obx(() {
      final items = _checkInQuestionsController.questionList;
      final loading = _checkInQuestionsController.isLoading.value;
      final apiItems = items.where((q) => q.isFromApi).toList();
      final defaultItems = items.where((q) => !q.isFromApi).toList();

      Widget shimmerRow() => Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        child: Container(
          height: 18.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      );

      Widget questionItem(CheckInQuestion q) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final selected = q.status.value;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        q.question,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      selected ? Icons.check_circle : Icons.check_circle_outline,
                      color: selected
                          ? const Color(0xFF69B427)
                          : Colors.white54,
                      size: 18.sp,
                    ),
                  ],
                );
              }),
              SizedBox(height: 10.h),
              if (q.isScale)
                Obx(() {
                  final v = q.scaleValue.value.round();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              localizations.commonAnswer,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Container(
                            height: 20.h,
                            width: 34.w,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: const Color(0xFF69B427),
                                width: 1.w,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$v',
                                style: TextStyle(
                                  color: const Color(0xFF69B427),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FullWidthSlider(
                        value: q.scaleValue.value,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (nv) =>
                            _checkInQuestionsController.setScale(q, nv),
                        overlayColor:
                            const Color(0xFF69B427).withOpacity(0.2),
                      ),
                    ],
                  );
                })
              else
                TextFormField(
                  controller: q.controller!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: localizations.commonAnswer,
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: const Color(0XFF0A0A1F),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: _showValidationErrors &&
                                q.answer.value.trim().isEmpty
                            ? Colors.red
                            : Colors.white24,
                        width: 1.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: _showValidationErrors &&
                                q.answer.value.trim().isEmpty
                            ? Colors.red
                            : Colors.white24,
                        width: 1.w,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(
                        color: const Color(0xFF69B427),
                        width: 1.w,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                  ),
                  onChanged: (v) => _checkInQuestionsController.setAnswer(q, v),
                ),
            ],
          ),
        );
      }

      Widget group({
        required String title,
        required List<CheckInQuestion> groupItems,
        bool showLoading = false,
      }) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0XFF101021),
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.all(12.sp),
          child: Column(
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
              SizedBox(height: 12.h),
              ...groupItems.map(questionItem),
              if (showLoading) ...[
                for (int i = 0; i < 3; i++) ...[
                  if (i > 0) SizedBox(height: 10.h),
                  shimmerRow(),
                ],
              ],
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          group(
            title: 'Coach add questions for you',
            groupItems: apiItems,
            showLoading: loading,
          ),
          SizedBox(height: 12.h),
          group(
            title: 'Default questions',
            groupItems: defaultItems,
          ),
        ],
      );
    });
  }

  Widget _filledField(
    String initialValue, {
    required String hint,
    required ValueChanged<String> onChanged,
    bool isError = false,
  }) {
    final borderColor = isError ? Colors.red : Colors.grey;
    return TextFormField(
      initialValue: initialValue,
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
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
    String initialValue, {
    required String hint,
    ValueChanged<String>? onChanged,
    bool isError = false,
  }) {
    final borderColor = isError ? Colors.red : Colors.grey;
    return TextFormField(
      initialValue: initialValue,
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
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: borderColor, width: 1.w),
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
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Column(
          children: [
            _ynOption(
              localizations.commonYes,
              value == true,
              () => onChanged(true),
            ),
            SizedBox(width: 16.w),
            _ynOption(
              localizations.commonNo,
              value == false,
              () => onChanged(false),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckInBloc, CheckInState>(
      builder: (context, state) {
        final localizations = AppLocalizations.of(context)!;
        final data = state.data;
        if (data == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _checkInQuestionsSection(localizations),
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
                      localizations.commonBack,
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
                    onPressed: () {
                      final bloc = context.read<CheckInBloc>();
                      final data = bloc.state.data;
                      if (data == null) return;

                      final questionsEmpty =
                          _checkInQuestionsController.hasAnyEmptyAnswer();

                      final hasEmpty = questionsEmpty;

                      if (hasEmpty) {
                        setState(() {
                          _showValidationErrors = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please answer all questions before continuing.',
                            ),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _showValidationErrors = false;
                      });

                      bloc.add(const CheckInStepSet(3));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1448),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: Color(0xFF2E2E5D)),
                      ),
                    ),
                    child: Text(
                      localizations.commonNext,
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
