import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/database_services/transaction_database/transaction_data_base.dart';
import 'package:money_tracker/model/transaction_model.dart';
import 'package:money_tracker/utils/app_colors.dart';
import 'package:money_tracker/utils/utilities.dart';

class ExpenseTransactionScreen extends StatefulWidget {
  const ExpenseTransactionScreen({super.key});

  @override
  State<ExpenseTransactionScreen> createState() =>
      _ExpenseTransactionScreenState();
}

class _ExpenseTransactionScreenState extends State<ExpenseTransactionScreen> {
  List<TransactionModel> allDataList = [];
  List<TransactionModel> expenseDataList = [];

  Future<List<TransactionModel>> getExpenseList() async {
    allDataList = await TransactionDataBaseFunctions().getData();
    for (TransactionModel data in allDataList) {
      if (data.type == "Expense") {
        expenseDataList.add(data);
      }
    }
    expenseDataList.sort((first, second) => second.date.compareTo(first.date));
    return expenseDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<TransactionModel>>(
            future: getExpenseList(),
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: ListView(children: [
                      SizedBox(height: 20.h),
                      Text(
                        'Your expense transactions are :-',
                        style: GoogleFonts.robotoCondensed(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp),
                      ),
                      SizedBox(height: 10.h),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: ((context, index) {
                            var value = snapshot.data![index];
                            return Card(
                              elevation: 5,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Container(
                                height: 80.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryColor,
                                        AppColors.scaffoldColor,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  color: AppColors.scaffoldColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.arrow_circle_down_rounded,
                                              size: 35.sp,
                                              color: AppColors.errorBorderColor,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  value.description,
                                                  style: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textColor),
                                                ),
                                                SizedBox(height: 10.h),
                                                Text(
                                                  Utilities()
                                                      .parseDate(value.date),
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.textColor),
                                                )
                                              ],
                                            ),
                                            Text(
                                              '₹ ${value.amount}',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors
                                                      .errorBorderColor),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          separatorBuilder: ((context, index) => SizedBox(
                                height: 10.h,
                              )),
                          itemCount: snapshot.data!.length),
                      SizedBox(
                        height: 14.h,
                      )
                    ]),
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
