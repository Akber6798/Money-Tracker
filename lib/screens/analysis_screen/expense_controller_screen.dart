import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/database_services/transaction_database/transaction_data_base.dart';
import 'package:money_tracker/model/transaction_model.dart';
import 'package:money_tracker/utils/app_colors.dart';
import 'package:money_tracker/utils/utilities.dart';

class ExpenseControllerScreen extends StatefulWidget {
  const ExpenseControllerScreen({super.key});

  @override
  State<ExpenseControllerScreen> createState() =>
      _ExpenseControllerScreenState();
}

class _ExpenseControllerScreenState extends State<ExpenseControllerScreen> {
  List<FlSpot> dataSet = [];

  DateTime today = DateTime.now();
  List<FlSpot> getExpensechartDatas(List<TransactionModel> entireData) {
    dataSet = [];
    List tempDataSet = [];
    for (TransactionModel data in entireData) {
      if (data.date.month == today.month && data.type == 'Expense') {
        tempDataSet.add(data);
      }
    }
    tempDataSet.sort(
      (a, b) => a.date.day.compareTo(b.date.day),
    );
    for (var i = 0; i < tempDataSet.length; i++) {
      dataSet.add(FlSpot(tempDataSet[i].date.day.toDouble(),
          tempDataSet[i].amount.toDouble()));
    }
    return dataSet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<TransactionModel>>(
            future: TransactionDataBaseFunctions().getData(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Center(
                      child: Lottie.asset(
                          height: 330.h,
                          width: 330.w,
                          'asset/animations/100757-not-found.json'),
                    ),
                  );
                } else {
                  getExpensechartDatas(snapshot.data!);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: dataSet.length < 2
                        ? SizedBox(
                            height: double.infinity,
                            child: Center(
                              child: Text(
                                'Not enough data to show the graph...',
                                style: GoogleFonts.robotoCondensed(
                                    color: AppColors.errorBorderColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(height: 20.h),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Your ${Utilities().getMonthName(today)} month expense graph :-',
                                  style: GoogleFonts.robotoCondensed(
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                height: 400.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppColors.scaffoldColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.primaryColor,
                                        width: 1.sp)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 30.h),
                                  child: LineChart(
                                    LineChartData(
                                        borderData: FlBorderData(show: false),
                                        lineBarsData: [
                                          LineChartBarData(
                                              color: AppColors.errorBorderColor,
                                              spots: getExpensechartDatas(
                                                  snapshot.data!),
                                              isCurved: false,
                                              barWidth: 2.5)
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }
            })));
  }
}
