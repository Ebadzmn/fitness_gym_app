import 'package:fitness_app/core/bloc/nav_bloc.dart';
import 'package:fitness_app/core/coreWidget/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      NavItem(icon: Icons.home_outlined, label: 'Home'),
      NavItem(icon: Icons.explore_outlined, label: 'Discover'),
      NavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    final pages = const [
      _Page(title: 'Home'),
      _Page(title: 'Discover'),
      _Page(title: 'Profile'),
    ];

    return BlocProvider(
      create: (_) => NavBloc(),
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(index: state.index, children: pages),
            bottomNavigationBar: CustomFloatingNavBar(
              selectedIndex: state.index,
              items: items,
              onItemSelected: (i) => context.read<NavBloc>().add(NavEvent(i)),
            ),
          );
        },
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String title;
  const _Page({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}