import 'package:flutter/material.dart';

class RowKeyValue extends StatelessWidget {
  final String rowKey;
  final String rowValue;

  const RowKeyValue({
    super.key,
    required this.rowKey,
    required this.rowValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                rowKey,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                rowValue,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
