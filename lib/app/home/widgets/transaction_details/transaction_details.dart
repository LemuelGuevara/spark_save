import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/transaction.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/row_key_value.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionModel transaction;
  final String date;

  const TransactionDetails({
    super.key,
    required this.transaction,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.receipt_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${transaction.type.toLowerCase() == "expense" ? "-" : "+"}₱${transaction.transactionAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 38,
                      color: transaction.type.toLowerCase() == "expense"
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    transaction.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    spacing: 10,
                    children: <Widget>[
                      RowKeyValue(
                        rowKey: 'Date',
                        rowValue: formatDateToReadable(date),
                      ),
                      RowKeyValue(
                        rowKey: 'Category',
                        rowValue: transaction.category,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RoundedButton(
                    onTap: () {},
                    label: "Edit Transaction",
                    backgroundColor: Colors.grey.shade100,
                    textColor: Colors.black87,
                  ),
                  RoundedButton(
                    onTap: () {
                      final appState =
                          Provider.of<ApplicationState>(context, listen: false);
                      appState.deleteTransaction(transaction.id).then((_) {
                        Navigator.pop(context);
                      }).catchError(
                        (e) {
                          print("Error adding transaction: $e");
                        },
                      );
                    },
                    label: "Delete Transaction",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
