import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_tracker/screens/transaction_screen/expense_controller_trans_screen.dart';
import 'package:money_tracker/screens/transaction_screen/income_controller_trans_screen.dart';
import 'package:money_tracker/utils/app_colors.dart';

class TransactionTabController extends StatefulWidget {
  const TransactionTabController({super.key});

  @override
  State<TransactionTabController> createState() =>
      _TransactionTabControllerState();
}

class _TransactionTabControllerState extends State<TransactionTabController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transactions'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            bottom: TabBar(
                indicatorColor: AppColors.primaryColor,
                indicatorWeight: 3,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Income',
                      style: GoogleFonts.robotoCondensed(
                          color: AppColors.greenColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Expense',
                      style: GoogleFonts.robotoCondensed(
                          color: AppColors.errorBorderColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp),
                    ),
                  )
                ]),
          ),
          body: const TabBarView(children: [
            IncomeTransactionScreen(),
            ExpenseTransactionScreen()
          ]),
        ),
      ),
    );
  }
}
