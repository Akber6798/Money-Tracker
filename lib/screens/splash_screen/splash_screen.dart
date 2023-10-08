import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/screens/add_name_screen/add_name_screen.dart';
import 'package:money_tracker/screens/bottom_bar_controller_screen/bottom_bar_controller_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkingNameAvailableOrNot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('asset/animations/129858-dancing-wallet-coins.json',
                  height: 300.h, width: 300.w),
              SizedBox(height: 10.h),
              Text(
                'Money Tracker',
                style: GoogleFonts.notoSerif(
                    textStyle: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 33.sp,
                        fontWeight: FontWeight.w500)),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkingNameAvailableOrNot() {
    Timer(const Duration(seconds: 5), () async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var name = preferences.getString('name');
      if (name == null) {
        Navigator.of(context).pushReplacement(PageRouteBuilder<void>(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: ((context, child) {
                  return Opacity(
                    opacity: animation.value,
                    child: AddNameScreen(),
                  );
                }),
              );
            }),
            transitionDuration: const Duration(milliseconds: 600)));
      } else {
        Navigator.of(context).pushReplacement(PageRouteBuilder<void>(
            pageBuilder: ((context, animation, secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: ((context, child) {
                  return Opacity(
                    opacity: animation.value,
                    child: BottomBarControllerScreen(),
                  );
                }),
              );
            }),
            transitionDuration: const Duration(milliseconds: 600)));
      }
    });
  }
}
