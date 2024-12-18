import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/pooling/widgets/pooling_form.dart';
import 'package:spark_save/app/pooling/widgets/pooling_member_list.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/core/utils.dart';
import 'package:spark_save/models/pooling.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/row_key_value.dart';

class PoolingDetails extends StatelessWidget {
  final Pooling pooling;

  const PoolingDetails({
    super.key,
    required this.pooling,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMMM d, yyyy').format(pooling.date.toDate());

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
                  formatCurrency(pooling.expenseAmount),
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  pooling.category,
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
                      rowValue: pooling.category,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                PoolingMemberList(
                  poolingMembers: pooling.members,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundedButton(
                  onTap: () {},
                  label: "Edit Pooling",
                  backgroundColor: Colors.grey.shade100,
                  textColor: Colors.black87,
                ),
                RoundedButton(
                  onTap: () {
                    final appState =
                        Provider.of<ApplicationState>(context, listen: false);
                    appState.deleteTransaction(pooling.id).then((_) {
                      Navigator.pop(context);
                    }).catchError(
                      (e) {
                        print("Error adding transaction: $e");
                      },
                    );
                  },
                  label: "Delete Pooling",
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
}
