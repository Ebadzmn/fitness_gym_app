import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checkIn_widgets.dart';
import 'package:fitness_app/presentation/checkIn/widgets/questions_tab.dart';
import 'package:fitness_app/presentation/checkIn/widgets/checking_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/coreWidget/full_width_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/data/repositories/fake_checkin_repository.dart';
import 'package:fitness_app/domain/usecases/checkin/get_checkin_initial_usecase.dart';
import 'package:fitness_app/domain/usecases/checkin/save_checkin_usecase.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_bloc.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_event.dart';
import 'package:fitness_app/presentation/checkIn/bloc/checkin_state.dart';

class CheckinPages extends StatelessWidget {
  const CheckinPages({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeCheckInRepository(),
      child: Builder(builder: (ctx) {
        final repo = RepositoryProvider.of<FakeCheckInRepository>(ctx);
        return BlocProvider(
          create: (_) => CheckInBloc(getInitial: GetCheckInInitialUseCase(repo), saveCheckIn: SaveCheckInUseCase(repo))..add(const CheckInInitRequested()),
          child: const _CheckInView(),
        );
      }),
    );
  }
}

class _CheckInView extends StatelessWidget {
  const _CheckInView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: Colors.white10,
            child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => context.pop()),
          ),
        ),
        title: Text("Check -In", style: AppTextStyle.appbarHeading),
        centerTitle: true,
      ),
      body: BlocConsumer<CheckInBloc, CheckInState>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) {
          if (state.status == CheckInStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Error')));
          }
          if (state.status == CheckInStatus.saved) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submitted')));
          }
        },
        builder: (context, state) {
          if (state.status == CheckInStatus.loading || state.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final step = state.data!.step;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                GestureDetector(onTap: () => context.read<CheckInBloc>().add(const CheckInStepSet(0)), child: CheckInStep(icon: Icons.person_outline, label: "Profile", isActive: step == 0, isCompleted: step > 0)),
                GestureDetector(onTap: () => context.read<CheckInBloc>().add(const CheckInStepSet(1)), child: CheckInStep(icon: Icons.camera_alt_outlined, label: "Photos", isActive: step == 1, isCompleted: step > 1)),
                GestureDetector(onTap: () => context.read<CheckInBloc>().add(const CheckInStepSet(2)), child: CheckInStep(icon: Icons.chat_bubble_outline, label: "Questions", isActive: step == 2, isCompleted: step > 2)),
                GestureDetector(onTap: () => context.read<CheckInBloc>().add(const CheckInStepSet(3)), child: CheckInStep(icon: Icons.check_circle_outline, label: "Checking", isActive: step == 3, isCompleted: step > 3)),
              ]),
              SizedBox(height: 30.h),
              _bodyForStep(step),
              SizedBox(height: 40.h),
              if (step == 3) ...[
                Row(children: [
                  Expanded(child: ElevatedButton(onPressed: () => context.read<CheckInBloc>().add(const CheckInStepSet(2)), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F0F3E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r), side: const BorderSide(color: Color(0xFF2E2E5D)))), child: Text('Back', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)))),
                  SizedBox(width: 12.w),
                  Expanded(child: ElevatedButton(onPressed: () => context.read<CheckInBloc>().add(const SubmitPressed()), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1F1F7E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r), side: const BorderSide(color: Color(0xFF2E2E5D)))), child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600))))
                ])
              ] else ...[
                SizedBox(width: double.infinity, height: 55.h, child: ElevatedButton(onPressed: () => context.read<CheckInBloc>().add(const CheckInNextPressed()), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F0F3E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r), side: const BorderSide(color: Color(0xFF2E2E5D)))), child: Text(step == 1 ? 'Upload' : 'Next', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600))))
              ]
            ]),
          );
        },
      ),
    );
  }

  Widget _bodyForStep(int step) {
    if (step == 0) {
      return Column(children: const [
        Row(children: [Icon(Icons.monitor_weight_outlined, color: Colors.white), SizedBox(width: 8), Text("Basic Data", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))]),
        SizedBox(height: 20),
        CheckInCard(title: "competition class", value: "Classic Physique", icon: Icons.emoji_events_outlined),
        CheckInCard(title: "Current Weight (kg)", value: "80.2 (kg)", showBadge: true),
        CheckInCard(title: "Average Weight in %", value: "80.2 (%)", showBadge: true),
      ]);
    } else if (step == 1) {
      return Column(children: [
        InstructionText(icon: Icons.description_outlined, text: "You Can Select Multiple Files, But At Least One File Must Be Chosen"),
        SizedBox(height: 16.h),
        FileUploadWidget(label: "Select File", onTap: () {}),
        SizedBox(height: 24.h),
        InstructionText(icon: Icons.play_circle_outline, text: "Only One Video Can Be Uploaded, And The Maximum File Size Is 500 MB."),
        SizedBox(height: 16.h),
        VideoUploadWidget(label: "Drag & drop video file", onTap: () {}),
      ]);
    } else if (step == 2) {
      return const QuestionsTab();
    } else if (step == 3) {
      return const CheckingTab();
    }
    return Container();
  }
}
 

 
