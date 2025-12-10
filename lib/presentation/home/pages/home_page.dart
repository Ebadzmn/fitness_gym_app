import 'package:fitness_app/core/config/assets_path.dart';
import 'package:fitness_app/core/coreWidget/appbar_widget.dart'; // আপনার উইজেট লোকেশন
import 'package:fitness_app/presentation/auth/pages/login_page.dart';
import 'package:fitness_app/presentation/checkIn/pages/checkIn_pages.dart';
import 'package:fitness_app/presentation/daily/daily_tracking/presentation/pages/daily_page.dart';
import 'package:fitness_app/presentation/daily/pages/daily_pages.dart';
import 'package:fitness_app/presentation/training/pages/training_pages.dart';
import 'package:fitness_app/presentation/nutrition/pages/nutrition_page.dart';
import 'package:fitness_app/presentation/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/bloc/nav_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedRadioValue = 1;

  final List<NavItem> _navItems = [
    NavItem(svgPath: AssetsPath.apb1, label: "Daily"),
    NavItem(svgPath: AssetsPath.apb2, label: "Check-in"),
    NavItem(svgPath: AssetsPath.apb3, label: "Training"),
    NavItem(svgPath: AssetsPath.apb4, label: "Diet"),
    NavItem(svgPath: AssetsPath.apb5, label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          final pages = const [
            DailyPage(),
            CheckinPages(),
            TrainingPages(),
            NutritionPage(),
            ProfilePage(),
          ];

          return Scaffold(
            body: IndexedStack(index: state.index, children: pages),

            bottomNavigationBar: CustomFloatingNavBar(
              selectedIndex: state.index,
              items: _navItems,
              onItemSelected: (index) =>
                  context.read<NavBloc>().add(NavEvent(index)),
            ),
          );
        },
      ),
    );
  }

  // কাস্টম রেডিও বাটন তৈরি করার ফাংশন
  Widget _customRadioButton({required int value, required String text}) {
    // এখানে _selectedRadioValue ব্যবহার করা হয়েছে
    bool isSelected = _selectedRadioValue == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRadioValue = value; // রেডিও বাটন আপডেট হবে
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color.fromARGB(255, 7, 130, 11)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.grey,
                  width: 1,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 8, // সাইজ একটু ছোট করা হয়েছে সুন্দর দেখানোর জন্য
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
