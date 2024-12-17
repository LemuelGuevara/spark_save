import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/home/widgets/net_total_card.dart';
import 'package:spark_save/app/home/widgets/transactions_list.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/transaction.dart'; // Ensure this is imported

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        NetTotal netTotal = getNetTotal(appState.transactions);

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              NetTotalCard(
                balance: netTotal.balance,
                income: netTotal.income,
                expenses: netTotal.expense,
              ),
              const SizedBox(
                height: 10.5,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                color: Colors.grey,
                child: TransactionsList(transactions: appState.transactions),
              ),
            ],
          ),
        );
      },
    );
  }
}
