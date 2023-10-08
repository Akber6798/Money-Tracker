// ignore_for_file: deprecated_member_use

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/utils/app_colors.dart';

class Utilities {
  showErrorMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.errorBorderColor,
        textColor: AppColors.textColor,
        fontSize: 16.sp);
  }

  String parseDate(DateTime date) {
    final formatDate = DateFormat.yMMMd().format(date);
    return formatDate;
  }

  String getMonthName(DateTime date) {
    final formatDate = DateFormat.MMMM().format(date);
    return formatDate;
  }
}
