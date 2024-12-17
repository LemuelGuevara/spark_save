import 'package:cloud_firestore/cloud_firestore.dart';

class Pooling {
  String id;
  num expenseAmount;
  String expenseName;
  Timestamp date;
  String category;
  String status;
  List<PoolingMember> members;

  Pooling({
    required this.id,
    required this.expenseAmount,
    required this.expenseName,
    required this.date,
    required this.category,
    required this.status,
    required List<PoolingMember> members,
  }) : members = members.map((member) {
          if (members.isEmpty) {
            throw Exception("Members list cannot be empty.");
          }
          num share = (expenseAmount / members.length);
          num roundedShare = num.parse(share.toStringAsFixed(2));
          return PoolingMember(
            id: member.id,
            name: member.name,
            shareAmount: roundedShare,
            isPaid: member.isPaid,
          );
        }).toList();
}

class PoolingMember {
  String id;
  String name;
  num shareAmount;
  bool isPaid;

  PoolingMember({
    required this.id,
    required this.name,
    required this.isPaid,
    this.shareAmount = 0,
  });
}
