import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/model/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const TRANSACTION_DB_NAME = 'transaction_database';

class TransactionDataBaseFunctions {
  
  List<TransactionModel> expenseList = [];

  Future<void> addData(TransactionModel model) async {
    final transactionBox =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionBox.put(model.id, model);
  }

  Future<List<TransactionModel>> getData() async {
    final transactionBox =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transactionBox.values.toList();
  }

  Future<void> deleteData(String id) async {
    final transactionBox =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionBox.delete(id);
  }

  Future<void> deleteAllData() async {
    final transactionBox =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    transactionBox.clear();
    SharedPreferences prefference = await SharedPreferences.getInstance();
    prefference.remove('name');
  }

  
}
