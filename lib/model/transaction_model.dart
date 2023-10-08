import 'package:hive_flutter/hive_flutter.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int amount;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String type;
  @HiveField(4)
  final DateTime date;

  TransactionModel(
      {required this.id,
      required this.amount,
      required this.description,
      required this.type,
      required this.date});
}
