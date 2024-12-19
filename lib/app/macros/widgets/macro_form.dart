import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/models/macro.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/core_widgets.dart';
import 'package:spark_save/presentation/widgets/inputs/form_input.dart';

class MacroForm extends StatefulWidget {
  final Macro? macro;

  const MacroForm({super.key, this.macro});

  @override
  State<MacroForm> createState() => _MacroFormState();
}

class _MacroFormState extends State<MacroForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final _macroFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.macro != null) {
      _nameController.text = widget.macro!.name;
      _categoryController.text = widget.macro!.category;
      _amountController.text = widget.macro!.amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Header(widget.macro == null ? 'Add Macro' : 'Edit Macro'),
              Form(
                key: _macroFormKey,
                child: Column(
                  spacing: 15,
                  children: <Widget>[
                    FormInput(
                      label: "Macro Name",
                      hintText: 'e.g. Green Carenderia',
                      controller: _nameController,
                    ),
                    FormInput(
                      label: "Category",
                      hintText: 'e.g. Food',
                      controller: _categoryController,
                    ),
                    FormInput(
                      label: "Amount",
                      hintText: '0.00',
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 40,
            top: 10,
          ),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundedButton(
                onTap: () {
                  if (_macroFormKey.currentState?.validate() ?? false) {
                    final macro = Macro(
                      id: widget.macro?.id ?? '',
                      amount: double.tryParse(_amountController.text) ?? 0.00,
                      name: _nameController.text,
                      date: Timestamp.now(),
                      category: _categoryController.text,
                    );

                    final appState =
                        Provider.of<ApplicationState>(context, listen: false);

                    if (widget.macro == null) {
                      appState.addMacro(macro).then((_) {
                        Navigator.pop(context);
                      }).catchError((e) {
                        print("Error adding macro: $e");
                      });
                    } else {
                      appState.updateMacro(macro).then((_) {
                        Navigator.pop(context);
                      }).catchError((e) {
                        print("Error updating macro: $e");
                      });
                    }
                  }
                },
                label: widget.macro == null ? 'Add Macro' : 'Update Macro',
                backgroundColor: widget.macro == null
                    ? Colors.green.shade800
                    : Colors.grey.shade300,
                textColor: widget.macro == null ? Colors.white : Colors.black,
              ),
              if (widget.macro != null)
                RoundedButton(
                  onTap: () {
                    final appState =
                        Provider.of<ApplicationState>(context, listen: false);
                    appState
                        .deleteDocument(widget.macro!.id, "macros")
                        .then((_) {
                      Navigator.pop(context);
                    }).catchError(
                      (e) {
                        print("Error deleting macro: $e");
                      },
                    );
                  },
                  label: "Delete Macro",
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
