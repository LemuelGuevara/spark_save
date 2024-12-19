import 'package:flutter/material.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/pooling.dart';

class PoolingMemberList extends StatelessWidget {
  final List<PoolingMember> poolingMembers;

  const PoolingMemberList({
    super.key,
    required this.poolingMembers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        color: Colors.grey.shade50,
        child: SizedBox(
          height: 220,
          child: ListView.builder(
            itemCount: poolingMembers.length,
            itemBuilder: (context, index) {
              final member = poolingMembers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    member.name[0].toUpperCase(), // First letter of the name
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                title: Text(
                  member.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Contribution: ${formatCurrency(member.shareAmount)}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: Badge(
                  backgroundColor: member.isPaid
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  label: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Text(
                      member.isPaid ? "Paid" : "Pending",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
