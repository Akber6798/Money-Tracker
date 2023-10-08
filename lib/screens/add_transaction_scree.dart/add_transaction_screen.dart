import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_tracker/database_services/transaction_database/transaction_data_base.dart';
import 'package:money_tracker/model/transaction_model.dart';
import 'package:money_tracker/utils/app_colors.dart';
import 'package:money_tracker/utils/utilities.dart';

class AddTransactionScreen extends StatefulWidget {
const  AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  int? amount;
  String? description;
  String type = "Income";
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Transaction'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 27.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            TextFormField(
              keyboardType: TextInputType.number,
              cursorColor: AppColors.primaryColor,
              style: TextStyle(color: AppColors.textColor),
              maxLength: 10,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee_rounded,
                    color: AppColors.textColor, size: 20.sp),
              ),
              onChanged: ((value) {
                try {
                  amount = int.parse(value);
                } catch (e) {
                  Utilities().showErrorMessage("Must have atleast one digit");
                }
              }),
            ),
            SizedBox(height: 20.h),
            TextFormField(
              keyboardType: TextInputType.text,
              maxLength: 20,
              decoration: InputDecoration(
                counterText: '',
                hintText: 'Description',
                prefixIcon: Icon(Icons.description_rounded,
                    color: AppColors.textColor, size: 20.sp),
              ),
              style: TextStyle(color: AppColors.textColor),
              onChanged: ((value) {
                description = value;
              }),
              cursorColor: AppColors.primaryColor,
            ),
            SizedBox(height: 50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  selectedColor: AppColors.primaryColor,
                  label: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Income',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                  selected: type == "Income" ? true : false,
                  onSelected: ((value) {
                    setState(() {
                      type = "Income";
                    });
                  }),
                ),
                ChoiceChip(
                  selectedColor: AppColors.primaryColor,
                  label: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      'Expense',
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  selected: type == "Expense" ? true : false,
                  onSelected: ((value) {
                    setState(() {
                      type = "Expense";
                    });
                  }),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            TextButton.icon(
                onPressed: () {
                  selectDatePro(context);
                },
                icon: Icon(
                  Icons.calendar_month_rounded,
                  size: 35.sp,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  selectedDate == null
                      ? 'Select Date'
                      : Utilities().parseDate(selectedDate!),
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor),
                )),
            SizedBox(height: 200.h),
            SizedBox(
              height: 50.h,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      backgroundColor: AppColors.primaryColor),
                  onPressed: () {
                    addTransaction();
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: AppColors.scaffoldColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> selectDatePro(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now(),
        builder: ((context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
              )),
              child: child!);
        }));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> addTransaction() async {
    if (amount == null || description == null || selectedDate == null) {
      Utilities().showErrorMessage('Please enter the required fields');
    } else {
      await TransactionDataBaseFunctions().addData(TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: amount!,
          description: description!,
          type: type,
          date: selectedDate!));
      Navigator.pop(context);
    }
  }
}
