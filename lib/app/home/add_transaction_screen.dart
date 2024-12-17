import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/inputs/form_input.dart';
import 'package:spark_save/presentation/widgets/inputs/rounded_tab_input.dart';
import 'package:spark_save/models/transaction.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _dateFieldController = TextEditingController();
  final TextEditingController _categoryFieldController =
      TextEditingController();
  final TextEditingController _amountFieldController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late TabController _tabController;
  final List<String> tabLabels = ['Expense', 'Income'];

  String selectedLabel = 'Expense';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedLabel = tabLabels[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Transaction",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              RoundedTabBar(
                label: "Transaction Type",
                tabController: _tabController,
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Expense',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Income',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  spacing: 20,
                  children: <Widget>[
                    FormInput(
                      label: 'Name',
                      hintText: 'e.g. PS5',
                      controller: _nameFieldController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: 'Category',
                      hintText: 'Category',
                      controller: _categoryFieldController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Category cannot be empty';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: "Amount",
                      hintText: '0.00',
                      keyboardType: TextInputType.number,
                      controller: _amountFieldController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount cannot be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RoundedButton(
            label: "Submit",
            backgroundColor: Colors.green.shade800,
            textColor: Colors.white,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                final transaction = TransactionModel(
                  id: '',
                  name: _nameFieldController.text,
                  category: _categoryFieldController.text,
                  transactionAmount:
                      double.tryParse(_amountFieldController.text) ?? 0.0,
                  type: selectedLabel,
                  date: Timestamp.now(),
                );

                final appState =
                    Provider.of<ApplicationState>(context, listen: false);

                appState.addTransaction(transaction).then((_) {
                  Navigator.pop(context);
                }).catchError(
                  (e) {
                    print("Error adding transaction: $e");
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
