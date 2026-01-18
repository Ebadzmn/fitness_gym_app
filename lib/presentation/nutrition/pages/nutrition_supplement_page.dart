import 'package:fitness_app/core/config/app_text_style.dart';
import 'package:fitness_app/core/config/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_bloc.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_event.dart';
import 'package:fitness_app/features/nutrition/presentation/pages/bloc/nutrition_supplement/nutrition_supplement_state.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

class NutritionSupplementPage extends StatelessWidget {
  const NutritionSupplementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<NutritionSupplementBloc>()
            ..add(const NutritionSupplementLoadRequested()),
      child: const _NutritionSupplementView(),
    );
  }
}

class _NutritionSupplementView extends StatelessWidget {
  const _NutritionSupplementView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          localizations.nutritionMenuSupplementTitle,
          style: AppTextStyle.appbarHeading,
        ),
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
      body: BlocBuilder<NutritionSupplementBloc, NutritionSupplementState>(
        builder: (context, state) {
          if (state.status == NutritionSupplementStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NutritionSupplementStatus.failure) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (state.status == NutritionSupplementStatus.success &&
              state.data != null) {
            final supplements = state.data!.items;
            return SingleChildScrollView(
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
                          Icon(
                            Icons.water_drop,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            localizations.nutritionSupplementsHeaderTitle,
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
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFF2E2E5D)),
                                ),
                              ),
                              children: [
                                _headerCell(
                                  localizations.nutritionSupplementsTableName,
                                ),
                                _headerCell(
                                  localizations
                                      .nutritionSupplementsTableDosage,
                                ),
                                _headerCell(
                                  localizations.nutritionSupplementsTableTime,
                                ),
                                _headerCell(
                                  localizations
                                      .nutritionSupplementsTablePurpose,
                                ),
                                _headerCell(
                                  localizations.nutritionSupplementsTableBrand,
                                ),
                                _headerCell(
                                  localizations
                                      .nutritionSupplementsTableComment,
                                ),
                              ],
                            ),
                            ...supplements.map(
                              (supplement) => _dataRow(
                                supplement.name,
                                supplement.dosage,
                                supplement.time,
                                supplement.purpose,
                                supplement.brand,
                                supplement.note, // Note mapped to Comment
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Text(
              localizations.nutritionSupplementsEmpty,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
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
