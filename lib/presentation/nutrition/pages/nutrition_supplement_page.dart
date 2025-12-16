import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionSupplementPage extends StatelessWidget {
  const NutritionSupplementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Supplement', style: AppTextStyle.appbarHeading),
        centerTitle: true,
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF13131F),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF2E2E5D)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Icon(Icons.water_drop, color: Colors.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'Supplement',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: const Color(0xFF2E2E5D), height: 1),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 800.w),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.2), // Name
                      1: FlexColumnWidth(1.2), // Dosage
                      2: FlexColumnWidth(0.8), // Time
                      3: FlexColumnWidth(0.8), // Purpose
                      4: FlexColumnWidth(1.2), // Brand
                      5: FlexColumnWidth(1.6), // Comment
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
                        ),
                        children: [
                          _headerCell('Name'),
                          _headerCell('Dosage'),
                          _headerCell('Time'),
                          _headerCell('Purpose'),
                          _headerCell('Brand'),
                          _headerCell('Comment'),
                        ],
                      ),
                      _dataRow('Multivitamin', '5g per day', 'Morning', 'General health', 'Brand A', 'Daily multivitamin'),
                      _dataRow('Vitamin C', '1 tab', 'Morning', 'Immune support', 'Brand B', 'With breakfast'),
                      _dataRow('Zinc', '1 tab', 'Night', 'Recovery', 'Brand C', 'Take before sleep'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  TableRow _dataRow(
    String name,
    String dosage,
    String time,
    String purpose,
    String brand,
    String comment,
  ) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2E2E5D))),
      ),
      children: [
        _dataCell(name),
        _dataCell(dosage),
        _dataCell(time),
        _dataCell(purpose),
        _dataCell(brand),
        _dataCell(comment),
      ],
    );
  }

  Widget _dataCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
