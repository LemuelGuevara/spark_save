import 'package:cloud_firestore/cloud_firestore.dart';

class Pooling {
  String id;
  String userId;
  num expense;
  Timestamp date;
  String category;
  String status;

  Pooling({
    required this.id,
    required this.userId,
    required this.expense,
    required this.date,
    required this.category,
    required this.status,
  });
}
