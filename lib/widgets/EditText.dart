import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  final String? hint;
  final String? value;
  final void Function(String)? onChanged;
  final TextInputType? inputType;

  const EditText({this.value, this.hint, this.onChanged, this.inputType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: TextField(
        controller: TextEditingController(text: value),
        onChanged: onChanged,
        keyboardType: inputType,
        // ignore: require_trailing_commas
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint,
        ),
      ),
    );
  }
}
