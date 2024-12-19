import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:spark_save/app/macros/widgets/macro_form.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/macro.dart';
import 'package:spark_save/models/transaction.dart';
import 'package:spark_save/app_router.dart';

class MacroList extends StatelessWidget {
  final List<Macro> macros;

  const MacroList({
    super.key,
    required this.macros,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: macros.map((macro) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final transaction = TransactionModel(
                      id: '',
                      name: macro.name,
                      category: macro.category,
                      transactionAmount: macro.amount,
                      type: 'Expense',
                      date: Timestamp.now(),
                    );

                    final appState =
                        Provider.of<ApplicationState>(context, listen: false);

                    appState.addTransaction(transaction).then((_) {
                      print("Transaction added successfully");
                      Get.find<AppRouterController>().selectedIndex.value = 0;
                    }).catchError((e) {
                      print("Error adding transaction: $e");
                    });
                  },
                  child: Card.outlined(
                    color: Colors.grey.shade50,
                    child: ListTile(
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
                        macro.name,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        macro.category,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      trailing: Text(
                        formatCurrency(macro.amount),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MacroForm(
                          macro: macro,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 24,
                  ),
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
