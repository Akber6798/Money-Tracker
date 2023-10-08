import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/analysis_screen/analysis_tab_controllerscreen.dart';
import 'package:money_tracker/screens/home_screen.dart/home_screen.dart';
import 'package:money_tracker/screens/settings_screen/settings_screen.dart';
import 'package:money_tracker/screens/transaction_screen/transaction_tab_controller_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';

class BottomBarControllerScreen extends StatelessWidget {
  BottomBarControllerScreen({super.key});

  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final List _screens = const [
    HomeScreen(),
    TransactionTabController(),
    AnalysisTabController(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: ((context, newValue, child) {
          return CurvedNavigationBar(
              index: newValue,
              height: 60,
              backgroundColor: AppColors.scaffoldColor,
              color: AppColors.primaryColor,
              animationDuration: const Duration(milliseconds: 400),
              onTap: (newIndex) {
                _selectedIndex.value = newIndex;
              },
              items: [
                Icon(Icons.home, size: 32, color: AppColors.scaffoldColor),
                Icon(Icons.history, size: 32, color: AppColors.scaffoldColor),
                Icon(Icons.insert_chart,
                    size: 32, color: AppColors.scaffoldColor),
                Icon(Icons.settings, size: 32, color: AppColors.scaffoldColor),
              ]);
        }),
      ),
      body: ValueListenableBuilder(
          valueListenable: _selectedIndex,
          builder: ((context, newValue, child) {
            return _screens[newValue];
          })),
    );
  }
}
