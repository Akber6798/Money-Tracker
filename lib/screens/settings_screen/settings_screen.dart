import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_tracker/database_services/transaction_database/transaction_data_base.dart';
import 'package:money_tracker/screens/add_name_screen/add_name_screen.dart';
import 'package:money_tracker/screens/splash_screen/splash_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Settings'),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageRouteBuilder<
                            void>(
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
                  },
                  child: SizedBox(
                    height: 60.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Change your name',
                          style: GoogleFonts.robotoCondensed(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 35.sp,
                          color: AppColors.errorBorderColor,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                InkWell(
                  onTap: () {
                    showRestDialogue(context);
                  },
                  child: SizedBox(
                    height: 60.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reset Everything',
                          style: GoogleFonts.robotoCondensed(
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 35.sp,
                          color: AppColors.errorBorderColor,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  showRestDialogue(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: AppColors.scaffoldColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Text(
              'Are you sure to reset everything?',
              style: GoogleFonts.robotoCondensed(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.robotoCondensed(
                      color: AppColors.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await TransactionDataBaseFunctions().deleteAllData();
                  Navigator.of(context).push(PageRouteBuilder<void>(
                      pageBuilder: ((context, animation, secondaryAnimation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: ((context, child) {
                            return Opacity(
                              opacity: animation.value,
                              child: const SplashScreen(),
                            );
                          }),
                        );
                      }),
                      transitionDuration: const Duration(milliseconds: 400)));
                },
                child: Text(
                  'Confirm',
                  style: GoogleFonts.robotoCondensed(
                      color: AppColors.errorBorderColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp),
                ),
              ),
            ],
          );
        }));
  }
}
