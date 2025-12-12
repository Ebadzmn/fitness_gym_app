import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/appRoutes/app_routes.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/features/training/data/repositories/fake_exercise_repository.dart';
import 'package:fitness_app/features/training/domain/usecases/get_exercises_usecase.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/exercise_bloc/exercise_bloc.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/exercise_bloc/exercise_event.dart';
import 'package:fitness_app/features/training/presentation/pages/bloc/exercise_bloc/exercise_state.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FakeExerciseRepository(),
      child: Builder(
        builder: (ctx) {
          final repo = RepositoryProvider.of<FakeExerciseRepository>(ctx);
          return BlocProvider(
            create: (_) =>
                ExerciseBloc(getExercises: GetExercisesUseCase(repo))
                  ..add(const ExerciseInitRequested()),
            child: const _ExerciseView(),
          );
        },
      ),
    );
  }
}

class _ExerciseView extends StatelessWidget {
  const _ExerciseView();

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
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text('Exercise', style: AppTextStyle.appbarHeading),
        centerTitle: true,
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state.status == ExerciseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(context, state.query),
                SizedBox(height: 16.h),
                _filters(context, state.currentFilter),
                SizedBox(height: 20.h),
                ...state.visible.map(
                  (e) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _exerciseCard(context, e),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchField(BuildContext context, String initial) {
    final ctrl = TextEditingController(text: initial);
    return TextFormField(
      controller: ctrl,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: 'Search Exercise',
        hintStyle: GoogleFonts.poppins(color: Colors.white70, fontSize: 14.sp),
        filled: true,
        fillColor: const Color(0XFF101021),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFF2E2E5D), width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFF2E2E5D), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: const Color(0xFF2E2E5D), width: 1.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
      ),
      onChanged: (v) =>
          context.read<ExerciseBloc>().add(ExerciseSearchChanged(v)),
    );
  }

  Widget _filters(BuildContext context, String current) {
    final filters = const ['All', 'Chest', 'Back', 'Legs'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final f in filters) ...[
            _filterChip(
              label: f,
              selected: current == f,
              onTap: () =>
                  context.read<ExerciseBloc>().add(ExerciseFilterSet(f)),
            ),
            SizedBox(width: 12.w),
          ],
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF43A047) : const Color(0xFF3A3A55),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _exerciseCard(BuildContext context, ExerciseEntity e) {
    return InkWell(
      onTap: () => context.push(AppRoutes.exerciseDetailPage, extra: e),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0XFF101021),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF2E2E5D)),
        ),
        padding: EdgeInsets.all(10.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2B2D3F),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.fitness_center, color: Colors.white, size: 28.sp),
          ),

            SizedBox(width: 12.w),

            // RIGHT SIDE CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      _smallChip(e.category, color: const Color(0xFF223522)),
                      SizedBox(width: 8.w),
                      const Icon(
                        Icons.fitness_center,
                        color: Colors.white70,
                        size: 14,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        e.equipment,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: [
                      for (final t in e.tags)
                        _smallChip(t, color: const Color(0xFF3A3A55)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallChip(String label, {required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
