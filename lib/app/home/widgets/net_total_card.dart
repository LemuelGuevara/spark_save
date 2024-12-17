import 'package:flutter/material.dart';

class NetTotalCard extends StatelessWidget {
  final num balance, income, expenses;

  const NetTotalCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(
          color: Colors.grey.shade200, 
          width: 1, 
        ),
      ),
      elevation: 0, // No shadow
      color: Colors.grey.shade100, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Net Total",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₱$balance",
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+$income",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "-$expenses",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
