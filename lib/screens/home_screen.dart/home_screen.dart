import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:money_tracker/database_services/transaction_database/transaction_data_base.dart';
import 'package:money_tracker/model/transaction_model.dart';
import 'package:money_tracker/screens/add_transaction_scree.dart/add_transaction_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';
import 'package:money_tracker/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalBalance = 0;
  int totalIncomeBalance = 0;
  int totalExpenseBalance = 0;
  late SharedPreferences pref;
  List<TransactionModel> allDataList = [];

  getname() async {
    pref = await SharedPreferences.getInstance();
  }

  getTotalBalance(List<TransactionModel> entireData) {
    totalBalance = 0;
    totalIncomeBalance = 0;
    totalExpenseBalance = 0;
    for (TransactionModel data in entireData) {
      if (data.type == 'Income') {
        totalBalance += data.amount;
        totalIncomeBalance += data.amount;
      } else {
        totalBalance -= data.amount;
        totalExpenseBalance += data.amount;
      }
    }
  }

  @override
  void initState() {
    getname();
    super.initState();
  }

  Future<List<TransactionModel>> getCorrectFormateDateList() async {
    allDataList = await TransactionDataBaseFunctions().getData();
    allDataList.sort((first, second) => second.date.compareTo(first.date));
    return allDataList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: ((context) {
                return AlertDialog(
                  backgroundColor: AppColors.scaffoldColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: Text(
                    'Are you sure to Exit?',
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
                        SystemNavigator.pop();
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
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Money Tracker'),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              Image(
                  height: 32.h,
                  width: 32.w,
                  image: const AssetImage("asset/icons/rupee.png")),
              SizedBox(width: 15.w)
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              Navigator.of(context)
                  .push(PageRouteBuilder<void>(
                      pageBuilder: ((context, animation, secondaryAnimation) {
                        return AnimatedBuilder(
                          animation: animation,
                          builder: ((context, child) {
                            return Opacity(
                              opacity: animation.value,
                              child: const AddTransactionScreen(),
                            );
                          }),
                        );
                      }),
                      transitionDuration: const Duration(milliseconds: 600)))
                  .whenComplete(() {
                setState(() {});
              });
            },
            child: Icon(
              Icons.add,
              size: 35.sp,
            ),
          ),
          body: FutureBuilder<List<TransactionModel>>(
              future: getCorrectFormateDateList(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                            'asset/animations/113070-empty-box-blue.json'),
                        Text(
                          'Hi ${pref.getString('name')}, nothing in here yet...\nClick the add button to get started',
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 16.sp,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    );
                  } else {
                    getTotalBalance(snapshot.data!);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: ListView(
                        children: [
                          SizedBox(height: 10.h),
                          Text(
                            'Hi ${pref.getString('name')} !',
                            style: GoogleFonts.robotoCondensed(
                                color: AppColors.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp),
                          ),
                          SizedBox(height: 10.h),
                          Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Container(
                              height: 150.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      const Color(0xff85FFBD),
                                      AppColors.primaryColor,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Your Balance',
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColor),
                                        ),
                                        Text(
                                          "₹ $totalBalance",
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textColor),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                    Icons
                                                        .arrow_circle_up_rounded,
                                                    size: 35.sp,
                                                    color:
                                                        AppColors.greenColor),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  "Income",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color:
                                                          AppColors.textColor),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '₹ $totalIncomeBalance',
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textColor),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                    Icons
                                                        .arrow_circle_down_rounded,
                                                    size: 35.sp,
                                                    color: AppColors
                                                        .errorBorderColor),
                                                SizedBox(width: 5.w),
                                                Text(
                                                  "Expense",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color:
                                                          AppColors.textColor),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '₹ $totalExpenseBalance',
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.textColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Recent Transactions :',
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
                                return Slidable(
                                  key: Key(value.id),
                                  startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: ((context) {
                                            setState(() {
                                              TransactionDataBaseFunctions()
                                                  .deleteData(value.id);
                                            });
                                          }),
                                          backgroundColor:
                                              AppColors.scaffoldColor,
                                          foregroundColor:
                                              AppColors.primaryColor,
                                          icon: Icons.delete,
                                          label: 'Delete',
                                        ),
                                      ]),
                                  child: Card(
                                    elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Container(
                                      height: 80.h,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      value.type == "Income"
                                                          ? Icons
                                                              .arrow_circle_up_rounded
                                                          : Icons
                                                              .arrow_circle_down_rounded,
                                                      size: 30.sp,
                                                      color: value.type ==
                                                              "Income"
                                                          ? AppColors.greenColor
                                                          : AppColors
                                                              .errorBorderColor,
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Text(
                                                      value.type,
                                                      style: TextStyle(
                                                        fontSize: 16.sp,
                                                        color:
                                                            AppColors.textColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  value.type == "Income"
                                                      ? '₹${value.amount}'
                                                      : '₹${value.amount}',
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: value.type ==
                                                            "Income"
                                                        ? AppColors.greenColor
                                                        : AppColors
                                                            .errorBorderColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  value.description,
                                                  style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.textColor),
                                                ),
                                                Text(
                                                  Utilities()
                                                      .parseDate(value.date),
                                                  style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppColors.otherColor),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              separatorBuilder: ((context, index) =>
                                  SizedBox(height: 10.h)),
                              itemCount: snapshot.data!.length),
                          SizedBox(
                            height: 14.h,
                          )
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
              }),
        ));
  }
}
