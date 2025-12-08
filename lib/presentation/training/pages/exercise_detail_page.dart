import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/domain/entities/training_entities/exercise_entity.dart';

class ExerciseDetailPage extends StatelessWidget {
  final ExerciseEntity exercise;
  const ExerciseDetailPage({super.key, required this.exercise});

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
        title: Text('Exercise', style: AppTextStyle.appbarHeading),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  exercise.imageUrl.isNotEmpty
                      ? exercise.imageUrl
                      : 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1470&q=80',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF2B2D3F)),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFF2B2D3F),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
              Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0x00000000), Color(0x66000000)], begin: Alignment.topCenter, end: Alignment.bottomCenter))))
              ,
              Positioned.fill(child: Center(child: Container(width: 52.w, height: 52.w, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle), child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28)))),
              Positioned(left: 16.w, bottom: 16.h, child: Text(exercise.title.toUpperCase(), style: GoogleFonts.poppins(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w700))),
            ]),
          ),
          SizedBox(height: 16.h),
          Text(exercise.description, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, height: 1.5)),
        ]),
      ),
    );
  }
}
