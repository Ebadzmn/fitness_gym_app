import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/core/config/app_text_style.dart'; // আপনার স্টাইল ফাইল ইম্পোর্ট করুন

class CustomAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showBackButton = true, // ডিফল্টভাবে ব্যাক বাটন দেখাবে
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// Center title
        Text(
          title,
          style: AppTextStyle.appbarHeading,
          textAlign: TextAlign.center,
        ),

        /// Back button (left aligned)
        if (showBackButton)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              // যদি onBackTap না দেওয়া হয়, তবে অটোমেটিক আগের পেজে ব্যাক করবে
              onPressed: onBackTap ?? () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 22.sp,
              ),
              // আইকনের ডিফল্ট প্যাডিং কমানোর জন্য (অপশনাল)
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
      ],
    );
  }
}