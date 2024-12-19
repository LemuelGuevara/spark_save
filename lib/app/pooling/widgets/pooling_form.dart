import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/models/pooling.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/inputs/form_input.dart';

class PoolingForm extends StatefulWidget {
  final Pooling? pooling;

  const PoolingForm({super.key, this.pooling});

  @override
  State<PoolingForm> createState() => _PoolingFormState();
}

class _PoolingFormState extends State<PoolingForm> {
  final TextEditingController _payerFieldController = TextEditingController();
  final TextEditingController _expenseNameFieldController =
      TextEditingController();
  final TextEditingController _expenseCategoryFieldController =
      TextEditingController();
  final TextEditingController _expenseAmountFieldController =
      TextEditingController();
  final TextEditingController _memberFieldController = TextEditingController();

  final _poolingFormKey = GlobalKey<FormState>();
  final _memberFormKey = GlobalKey<FormState>();

  final List<PoolingMember> _poolingMembers = [];

  @override
  void initState() {
    super.initState();
    if (widget.pooling != null) {
      _payerFieldController.text = widget.pooling!.payer;
      _expenseNameFieldController.text = widget.pooling!.expenseName;
      _expenseCategoryFieldController.text = widget.pooling!.category;
      _expenseAmountFieldController.text =
          widget.pooling!.expenseAmount.toString();
      _poolingMembers.addAll(widget.pooling!.members);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        scrolledUnderElevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.pooling == null ? 'Add Pooling' : 'Edit Pooling',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _poolingFormKey,
                child: Column(
                  spacing: 15,
                  children: <Widget>[
                    FormInput(
                      label: 'Payer',
                      hintText: 'e.g. John Doe',
                      controller: _payerFieldController,
                    ),
                    FormInput(
                      label: 'Expense Name',
                      hintText: 'e.g. Bowling 12/24',
                      controller: _expenseNameFieldController,
                    ),
                    FormInput(
                      label: 'Category',
                      hintText: 'Category',
                      controller: _expenseCategoryFieldController,
                    ),
                    FormInput(
                      label: 'Expense Amount',
                      hintText: '0.00',
                      controller: _expenseAmountFieldController,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Members",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_poolingMembers.isNotEmpty)
                    Column(
                      children: _poolingMembers.asMap().entries.map((entry) {
                        final int index = entry.key;
                        final PoolingMember member = entry.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FormInput(
                                  hintText: member.name,
                                  controller:
                                      TextEditingController(text: member.name),
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _poolingMembers.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Text(
                      "No members added yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  SizedBox(height: 10),
                  RoundedButton(
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        isDismissible: false,
                        context: context,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SafeArea(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Scaffold(
                                appBar: AppBar(
                                  automaticallyImplyLeading: false,
                                  scrolledUnderElevation: 0.0,
                                  title: Text("Add Member"),
                                  centerTitle: false,
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        icon: const Icon(Icons.close_rounded),
                                      ),
                                    ),
                                  ],
                                ),
                                body: Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Form(
                                      key: _memberFormKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          FormInput(
                                            label: 'Name of Member',
                                            hintText: 'e.g. John Doe',
                                            controller: _memberFieldController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'Member name cannot be empty';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                bottomNavigationBar: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 10.0,
                                  ),
                                  child: RoundedButton(
                                    onTap: () {
                                      if (_memberFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _poolingMembers.add(
                                            PoolingMember(
                                              id: UniqueKey().toString(),
                                              name: _memberFieldController.text
                                                  .trim(),
                                              shareAmount: 0,
                                              isPaid: false,
                                            ),
                                          );
                                          _memberFieldController.clear();
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    label: 'Add Member',
                                    backgroundColor: Colors.green.shade800,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    label: "Add Member",
                    backgroundColor: Colors.grey.shade100,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: RoundedButton(
            onTap: () {
              // Check if there are at least 2 members
              if (_poolingMembers.length < 2) {
                // Show an error if fewer than 2 members
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You must add at least 2 members.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (_poolingFormKey.currentState?.validate() ?? false) {
                Pooling pooling = Pooling(
                  id: widget.pooling?.id ?? '',
                  payer: _payerFieldController.text,
                  expenseAmount:
                      double.tryParse(_expenseAmountFieldController.text) ??
                          0.00,
                  expenseName: _expenseNameFieldController.text,
                  date: Timestamp.now(),
                  category: _expenseCategoryFieldController.text,
                  status: 'Pending',
                  members: _poolingMembers,
                );

                final appState =
                    Provider.of<ApplicationState>(context, listen: false);

                if (widget.pooling != null) {
                  appState.updatePooling(pooling).then((_) {
                    Navigator.pop(context);
                  }).catchError((e) {
                    print("Error updating pooling: $e");
                  });
                } else {
                  appState.addPooling(pooling).then((_) {
                    Navigator.pop(context);
                  }).catchError((e) {
                    print("Error adding pooling: $e");
                  });
                }
              }
            },
            label: widget.pooling == null ? 'Add Pooling' : 'Update Pooling',
            backgroundColor: Colors.green.shade800,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
