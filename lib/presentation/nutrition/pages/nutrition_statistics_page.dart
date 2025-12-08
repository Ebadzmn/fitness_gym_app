import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class NutritionStatisticsPage extends StatelessWidget {
  const NutritionStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('Statistics', style: AppTextStyle.appbarHeading),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Macros', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 20.h),
            _buildMacrosSection(),
            SizedBox(height: 30.h),
            Text('Calories', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 20.h),
            _buildCaloriesChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildMacrosSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 120.r,
          width: 120.r,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40.r,
              sections: [
                PieChartSectionData(
                  color: const Color(0xFF43A047), // Green
                  value: 25,
                  title: '',
                  radius: 20.r,
                ),
                PieChartSectionData(
                  color: const Color(0xFF4A6CF7), // Blue
                  value: 35,
                  title: '',
                  radius: 20.r,
                ),
                PieChartSectionData(
                  color: const Color(0xFFFF6D00), // Orange/Brown
                  value: 40, // 55% in image but 25+35+55 != 100. Image says 55 fats, 35 carbs, 25 proteins = 115%. Let's normalize or follow text.
                  // Text says: Proteins 25%, Carbs 35%, Fats 55% (Wait, 25+35=60. 100-60=40. The image text "55%" might be a typo in the design or I'm misreading. Let's stick to visual proportions or just use the text values provided in image if possible, but for chart logic 25/35/40 sums to 100.)
                  // Let's use 25, 35, 40 for the chart visual.
                  title: '',
                  radius: 20.r,
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _legendItem(const Color(0xFF43A047), 'Proteins 25%', '100g'),
            SizedBox(height: 12.h),
            _legendItem(const Color(0xFF4A6CF7), 'Carbs 35%', '80g'),
            SizedBox(height: 12.h),
            _legendItem(const Color(0xFFFF6D00), 'Fats 55%', '60g'), // Keeping text same as image even if math is off
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 100.w,
          child: Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600)),
        ),
        Text(value, style: GoogleFonts.poppins(color: const Color(0xFFB0B0B0), fontSize: 14.sp, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildCaloriesChart() {
    return Container(
      height: 220.h,
      width: double.infinity,
      padding: EdgeInsets.only(right: 16.w, top: 10.h),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 500,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white10,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const titles = ['Mon', 'Tue', 'Wed', 'Thus', 'Fri', 'Sat', 'Sun'];
                  if (value.toInt() < 0 || value.toInt() >= titles.length) return const SizedBox();
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      titles[value.toInt()],
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 500,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: GoogleFonts.poppins(color: const Color(0xFFB0B0B0), fontSize: 12.sp),
                    textAlign: TextAlign.left,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 1600,
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1200),
                FlSpot(1, 1050),
                FlSpot(2, 1100),
                FlSpot(3, 1400),
                FlSpot(4, 1150),
                FlSpot(5, 1300),
                FlSpot(6, 700),
              ],
              isCurved: true,
              color: const Color(0xFF4A6CF7),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4A6CF7).withValues(alpha: 0.5),
                    const Color(0xFF4A6CF7).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
