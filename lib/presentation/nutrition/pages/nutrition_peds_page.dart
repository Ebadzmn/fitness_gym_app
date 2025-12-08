import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class NutritionPEDsPage extends StatelessWidget {
  const NutritionPEDsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text('PEDs', style: AppTextStyle.appbarHeading),
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
      body: Padding(
        padding: EdgeInsets.only(top: 20.h, left: 16.w, right: 16.w, bottom: 20.h),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C2E),
            borderRadius: BorderRadius.circular(8.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: _buildTable(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    // Define column widths
    final double col1Width = 80.w;
    final double col2Width = 100.w;
    final double colDosageWidth = 60.w;
    final double colFreqWidth = 60.w;
    final double colDayWidth = 50.w;

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: FixedColumnWidth(col1Width),
        1: FixedColumnWidth(col2Width),
        2: FixedColumnWidth(colDosageWidth),
        3: FixedColumnWidth(colFreqWidth),
        4: FixedColumnWidth(colDayWidth), // MO
        5: FixedColumnWidth(colDayWidth), // TU
        6: FixedColumnWidth(colDayWidth), // WE
        7: FixedColumnWidth(colDayWidth), // TH
        8: FixedColumnWidth(colDayWidth), // FR
        9: FixedColumnWidth(colDayWidth), // SA
        10: FixedColumnWidth(colDayWidth), // SU
      },
      border: TableBorder.all(color: const Color(0xFF4A3455), width: 1),
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(color: Colors.white),
          children: [
            Container(height: 30.h, color: const Color(0xFF1C1C2E)), // Empty above Category
            Container(
              height: 30.h,
              color: const Color(0xFF1C1C2E),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 8.w),
              child: Text('WEEK 1', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ),
            _headerCell('Dosage'),
            _headerCell('Frequency'),
            _headerCell('MO'),
            _headerCell('TUE'),
            _headerCell('WED'),
            _headerCell('THU'),
            _headerCell('FRI'),
            _headerCell('SAT'),
            _headerCell('SUN'),
          ],
        ),
        // Data Rows
        ..._buildCategoryRows('TEST', ['TEST E', 'TEST P', 'HALOTESTIN', 'DIANABOL', 'PRIMOBOLAN', 'MASTERON', 'ANAVAR']),
        ..._buildCategoryRows('DHT', ['PROVIRON', 'WINSTROL', 'ANADROL']),
        ..._buildCategoryRows('19-NOR', ['NPP', 'DECA', 'TRENE']),
        ..._buildCategoryRows('ESTROGEN & FERTILITY\nMANAGEMENT', ['ANASTROZOLE', 'EXEMESTANE', 'NOLVADEX', 'CLOMID', 'HCG', 'ARIMIDEX']),
        ..._buildCategoryRows('FATLOSS', ['YOHIMBINE', 'CLEN', 'MOM']),
        ..._buildCategoryRows('THYROID', ['T3', 'T4'], filledItem: 'T3', dosage: '4.0 mg', freq: 'ED', dayVal: '4.0 IU'),
        ..._buildCategoryRows('INSULIN', ['LANTUS', 'NOVORAPID']),
        ..._buildCategoryRows('OTHER', ['TELMISARTAN', 'METFORMIN', 'TB500', 'BPC-157']),
        ..._buildCategoryRows('PEPTIDES', ['MOTSC', 'SLU-PP-332']),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Container(
      height: 30.h,
      alignment: Alignment.center,
      color: Colors.white,
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.w600),
      ),
    );
  }

  List<TableRow> _buildCategoryRows(
    String category,
    List<String> items, {
    String? filledItem,
    String? dosage,
    String? freq,
    String? dayVal,
  }) {
    List<TableRow> rows = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isFilled = item == filledItem;
      
      rows.add(TableRow(
        decoration: const BoxDecoration(color: Color(0xFF3C2A45)), // Row background color
        children: [
          // Category Cell (only for first item, otherwise placeholder but handled by row structure visual)
          // Since TableRow cells must exist, we render a cell.
          // To mimic rowspan visually in Table widget (which doesn't support rowspan natively easily),
          // we can just render the text only on the middle row or top row, and clear borders?
          // But TableBorder.all puts borders everywhere.
          // Alternatively, we repeat the category name or leave empty.
          // The design shows merged cells.
          // A hack for "merged" look with TableBorder.all is hard.
          // Instead, I'll just put the text in the middle row of the group if I knew the height,
          // or just put it in the first row.
          // Let's put it in the first row for now, or use a separate column approach if strict.
          // For "same to same", I will just put the text in the vertical center.
          // I will use a Container with same color to hide internal borders if possible? No.
          // I'll just render the category name in the first cell, and empty strings in others.
          Container(
            height: 35.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            color: const Color(0xFF5A4565), // Category column slightly different color?
            child: i == items.length ~/ 2
                ? Text(category, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold))
                : null,
          ),
          Container(
            height: 35.h,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(item, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp)),
          ),
          _dataCell(isFilled ? dosage ?? '' : ''),
          _dataCell(isFilled ? freq ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
          _dataCell(isFilled ? dayVal ?? '' : ''),
        ],
      ));
    }
    return rows;
  }

  Widget _dataCell(String text) {
    return Container(
      height: 35.h,
      alignment: Alignment.center,
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10.sp)),
    );
  }
}
