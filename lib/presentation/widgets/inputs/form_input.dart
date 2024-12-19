import 'package:flutter/material.dart';

class FormInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? label;
  final bool? obscuredText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const FormInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.label,
    this.obscuredText,
    this.keyboardType,
    this.validator,
  });

  @override
  FormInputState createState() => FormInputState();
}

class FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscuredText ?? false,
          style: const TextStyle(fontSize: 16),
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green.shade800,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          validator: widget.validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
        ),
      ],
    );
  }
}
