import 'package:flutter/material.dart';
import 'package:spark_save/models/pooling.dart';
import 'package:spark_save/presentation/widgets/inputs/form_input.dart';

class PoolingForm extends StatelessWidget {
  final Pooling? pooling; // Nullable type
  final TextEditingController expenseNameController;
  final TextEditingController categoryController;
  final TextEditingController amountController;
  final GlobalKey<FormState> formKey;
  final bool isEdit;

  const PoolingForm({
    super.key,
    this.pooling, // Nullable field
    required this.expenseNameController,
    required this.categoryController,
    required this.amountController,
    required this.formKey,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEdit && pooling != null) {
      expenseNameController.text = pooling!.expenseName;
      categoryController.text = pooling!.category;
      amountController.text = pooling!.expenseAmount.toString();
    }

    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: <Widget>[
          FormInput(
            label: 'Expense Name',
            hintText: 'e.g. Bowling 12/24',
            controller: expenseNameController,
          ),
          FormInput(
            label: 'Category',
            hintText: 'Category',
            controller: categoryController,
          ),
          FormInput(
            label: 'Expense Amount',
            hintText: '0.00',
            controller: amountController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
