import 'package:flutter/material.dart';

class NumberInput extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const NumberInput({super.key, required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
