import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  final TextEditingController _expenseAmountFieldController =
      TextEditingController();
  final TextEditingController _memberFieldController = TextEditingController();

  final _poolingFormKey = GlobalKey<FormState>();
  final _memberFormKey = GlobalKey<FormState>();

  final List<String> _poolingMembers = [];

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
              Form(
                key: _poolingFormKey,
                child: Column(
                  spacing: 20,
                  children: <Widget>[
                    FormInput(
                      label: 'Expense Name',
                      hintText: 'e.g. Bowling 12/24',
                      controller: _expenseNameFieldController,
                    ),
                    FormInput(
                      label: 'Expense Amount',
                      hintText: '0.00',
                      controller: _expenseAmountFieldController,
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
                        final String member = entry.value;
                        final TextEditingController memberController =
                            TextEditingController(text: member);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: FormInput(
                                    hintText: member,
                                    controller: memberController),
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
                                              _memberFieldController.text
                                                  .trim());
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
            onTap: () {},
            label: 'Add Pooling',
            backgroundColor: Colors.green.shade800,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
