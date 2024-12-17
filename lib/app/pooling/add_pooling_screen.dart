import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:spark_save/app/pooling/widgets/pooling_form.dart';
import 'package:spark_save/app_state.dart';
import 'package:spark_save/models/pooling.dart';
import 'package:spark_save/presentation/widgets/buttons/rounded_button.dart';
import 'package:spark_save/presentation/widgets/inputs/form_input.dart';

class AddPoolingScreen extends StatefulWidget {
  const AddPoolingScreen({super.key});

  @override
  State<AddPoolingScreen> createState() => _AddPoolingScreenState();
}

class _AddPoolingScreenState extends State<AddPoolingScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add Pooling',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PoolingForm(
                expenseNameController: _expenseNameFieldController,
                categoryController: _expenseCategoryFieldController,
                amountController: _expenseAmountFieldController,
                formKey: _poolingFormKey,
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
                        context: context,
                        builder: (context) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SafeArea(
                              child: Scaffold(
                                body: Column(
                                  children: <Widget>[
                                    Form(
                                      key: _memberFormKey,
                                      child: FormInput(
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
                                    )
                                  ],
                                ),
                                bottomNavigationBar: SafeArea(
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
              Pooling pooling = Pooling(
                id: '',
                expenseAmount:
                    double.tryParse(_expenseAmountFieldController.text) ?? 0.00,
                expenseName: _expenseNameFieldController.text,
                date: Timestamp.now(),
                category: _expenseCategoryFieldController.text,
                status: 'Pending',
                members: _poolingMembers,
              );

              final appState =
                  Provider.of<ApplicationState>(context, listen: false);

              appState.addPooling(pooling).then((_) {
                Navigator.pop(context);
              }).catchError(
                (e) {
                  print("Error adding pooling: $e");
                },
              );
            },
            label: 'Add Pooling',
            backgroundColor: Colors.green.shade800,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
