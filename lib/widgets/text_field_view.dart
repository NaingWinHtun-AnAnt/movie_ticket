import 'package:flutter/material.dart';

class TextFieldView extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final bool italicLabel;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  TextFieldView({
    this.labelText,
    required this.hintText,
    this.italicLabel = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Colors.grey,
          fontStyle: italicLabel ? FontStyle.italic : FontStyle.normal,
        ),
        hintText: hintText,
      ),
      style: TextStyle(
        color: Colors.black87,
      ),
      validator: (text) {
        return text == null || text.isEmpty ? "This field is require!" : null;
      },
    );
  }
}
