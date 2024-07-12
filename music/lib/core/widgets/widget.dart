import 'package:flutter/material.dart';

class CustomForm extends StatelessWidget {
  const CustomForm({
    super.key,
    this.controller,
    required this.label,
    this.password = false,
    this.type = TextInputType.text,
    this.validator,
  });

  final TextEditingController? controller;
  final String label;
  final bool password;
  final TextInputType type;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enableInteractiveSelection: true,
      controller: controller,
      obscureText: password,
      keyboardType: type,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}