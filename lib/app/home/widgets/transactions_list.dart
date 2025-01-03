import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spark_save/app/home/transaction_details.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key, required this.transactions});

  final List<TransactionModel> transactions;

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  Map<String, List<TransactionModel>> _groupTransactionsByDate() {
    Map<String, List<TransactionModel>> groupedTransactions = {};

    for (var transaction in widget.transactions) {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(transaction.date.toDate());

      if (groupedTransactions.containsKey(formattedDate)) {
        groupedTransactions[formattedDate]!.add(transaction);
      } else {
        groupedTransactions[formattedDate] = [transaction];
      }
    }

    return groupedTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            width: double.infinity,
            child: Column(
              children: [
                for (var date in groupedTransactions.keys) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 10.0,
                      ),
                      child: Text(
                        DateFormat('MMMM d, yyyy').format(
                          DateTime.parse(date),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ...groupedTransactions[date]!.map(
                    (transaction) {
                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        child: ListTile(
                          onTap: () {
                            showCupertinoModalBottomSheet(
                              duration: Duration(milliseconds: 200),
                              expand: false,
                              useRootNavigator: true,
                              context: context,
                              builder: (context) => TransactionDetails(
                                transaction: transaction,
                              ),
                            );
                          },
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.receipt_long_rounded,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            transaction.name,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            transaction.category,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          trailing: Text(
                            transaction.type.toLowerCase() == "expense"
                                ? "-${formatCurrency(transaction.transactionAmount)}"
                                : "+${formatCurrency(transaction.transactionAmount)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
