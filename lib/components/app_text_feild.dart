import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    super.key,
    this.label,
    this.validator,
    required this.controller,
  });

  String? label;
  TextEditingController controller;
  Function(String? input)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: label != null ? Text(label.toString()) : null,
      ),
      controller: controller,
      validator: (value) => validator?.call(value),
    );
  }
}
