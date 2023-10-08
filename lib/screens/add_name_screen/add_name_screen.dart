import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/screens/bottom_bar_controller_screen/bottom_bar_controller_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';
import 'package:money_tracker/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNameScreen extends StatelessWidget {
  AddNameScreen({super.key});
  final nameController = TextEditingController();

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Lottie.asset('asset/animations/37270-robot-says-hi.json',
                      height: 300.h, width: 300.w),
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What can I call you?',
                      style: GoogleFonts.notoSerif(
                          textStyle: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    style: TextStyle(color: AppColors.textColor),
                    cursorColor: AppColors.primaryColor,
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                  ),
                  SizedBox(height: 100.h),
                  SizedBox(
                    height: 50.h,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            backgroundColor: AppColors.primaryColor),
                        onPressed: () async {
                          final name = nameController.text;
                          if (name.isEmpty) {
                            Utilities().showErrorMessage('Enter you name');
                          } else {
                            await addName(name);
                            Navigator.of(context).push(PageRouteBuilder<void>(
                                pageBuilder:
                                    ((context, animation, secondaryAnimation) {
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
                                transitionDuration:
                                    const Duration(milliseconds: 400)));
                            nameController.clear();
                          }
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: AppColors.scaffoldColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addName(String name) async {
    SharedPreferences prefference = await SharedPreferences.getInstance();
    prefference.setString('name', name);
  }
}
