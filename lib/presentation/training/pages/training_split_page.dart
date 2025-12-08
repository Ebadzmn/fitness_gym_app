import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/features/training/data/repositories/fake_training_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_training_split_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_split_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_split_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/training_split_state.dart';

class TrainingSplitPage extends StatelessWidget {
  const TrainingSplitPage({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeTrainingRepository(),
      child: Builder(builder: (ctx) {
        final repo = RepositoryProvider.of<FakeTrainingRepository>(ctx);
        return BlocProvider(
          create: (_) => TrainingSplitBloc(getSplit: GetTrainingSplitUseCase(repo))..add(const TrainingSplitInitRequested()),
          child: const _TrainingSplitView(),
        );
      }),
    );
  }
}

class _TrainingSplitView extends StatelessWidget {
  const _TrainingSplitView();
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
        title: Text('Training Split', style: AppTextStyle.appbarHeading),
        centerTitle: true,
      ),
      body: BlocBuilder<TrainingSplitBloc, TrainingSplitState>(builder: (context, state) {
        if (state.status == TrainingSplitStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: _splitTable(state.items),
        );
      }),
    );
  }

  Widget _splitTable(List items) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E2E5D)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(12.sp),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C2E),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(children: [
              Expanded(child: Text('Day', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600))),
              Expanded(child: Align(alignment: Alignment.centerLeft, child: Text('Work', style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600))))
            ]),
          ),
          const Divider(color: Color(0xFF2E2E5D), height: 1),
          for (final row in items) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              child: Row(children: [
                Expanded(child: Text(row.dayLabel, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp))),
                Expanded(child: Align(alignment: Alignment.centerLeft, child: Text(row.work, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp))))
              ]),
            ),
            const Divider(color: Color(0xFF2E2E5D), height: 1),
          ]
        ]),
      ),
    );
  }
}
