import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String name;
  Timestamp date;
  String type;
  String category;
  num transactionAmount;

  TransactionModel({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.category,
    required this.transactionAmount,
  });
}

class NetTotal {
  num balance, expense, income;

  NetTotal({
    required this.balance,
    required this.expense,
    required this.income,
  });
}
