import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool? isRequired;
  final Function? onChanged;
  final String theme;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.isRequired,
    this.onChanged,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      onChanged: onChanged == null ? null : onChanged!(),
      style: TextStyle(color: theme == "dark" ? Colors.white : Colors.black, fontWeight: FontWeight.w500, fontSize: 17),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 123, 123, 123), fontWeight: FontWeight.w500),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme == "dark" ? Color.fromARGB(255, 149, 149, 149) : Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: theme == "dark" ? Colors.white : Colors.black,
          ),
        ),
        errorStyle: const TextStyle(height: 0),
      ),
      maxLength: maxLength,
      validator: (val) {
        if (isRequired != false && (val == null || val.isEmpty)) {
          return '';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: maxLines,
    );
  }
}
