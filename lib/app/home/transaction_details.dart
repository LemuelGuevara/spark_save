import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/home/widgets/transaction_form.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/models/transaction.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/row_key_value.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetails({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        return FutureBuilder<TransactionModel?>(
          future: appState.retrieveTransactionById(transaction.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Container();
            } else {
              final retrievedTransaction = snapshot.data!;
              final formattedDate = DateFormat('MMMM d, yyyy')
                  .format(retrievedTransaction.date.toDate());

              return SafeArea(
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
                            '${retrievedTransaction.type.toLowerCase() == "expense" ? "-" : "+"}₱${retrievedTransaction.transactionAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 38,
                              color: retrievedTransaction.type.toLowerCase() ==
                                      "expense"
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            retrievedTransaction.name,
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
                                rowValue: formattedDate,
                              ),
                              RowKeyValue(
                                rowKey: 'Category',
                                rowValue: retrievedTransaction.category,
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TransactionForm(
                                          transaction: retrievedTransaction),
                                ),
                              );
                            },
                            label: "Edit Transaction",
                            backgroundColor: Colors.grey.shade100,
                            textColor: Colors.black87,
                          ),
                          RoundedButton(
                            onTap: () {
                              appState
                                  .deleteDocument(
                                      retrievedTransaction.id, "transactions")
                                  .then((_) {
                                Navigator.pop(context);
                              }).catchError((e) {
                                print("Error deleting transaction: $e");
                              });
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
              );
            }
          },
        );
      },
    );
  }
}
