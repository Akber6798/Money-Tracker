import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/model/transaction_model.dart';
import 'package:money_tracker/screens/splash_screen/splash_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              theme: ThemeData.light().copyWith(
                  scaffoldBackgroundColor: AppColors.scaffoldColor,
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.scaffoldColor,
                    elevation: 0,
                    centerTitle: true,
                    iconTheme: IconThemeData(
                        color: AppColors.secondaryColor, size: 25.sp),
                    titleTextStyle: GoogleFonts.robotoCondensed(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(color: AppColors.textLightColor),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(20)),
                  )));
        });
  }
}
