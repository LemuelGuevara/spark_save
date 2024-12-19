import 'package:cloud_firestore/cloud_firestore.dart';

class Macro {
  String id;
  String name;
  String category;
  num amount;
  Timestamp date;

  Macro({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
  });
}
