import 'package:flutter/material.dart';

class ValidatingTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final bool isValid;
  final bool isInvalid;
  final String hintText;
  final IconData? prefixIcon;

  const ValidatingTextFormField({
    super.key,
    required this.controller,
    this.onChanged,
    this.isLoading = false,
    this.isValid = false,
    this.isInvalid = false,
    required this.hintText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        suffixIcon:
            isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator.adaptive(),
                )
                : isValid == true
                ? Icon(Icons.check, color: Colors.green)
                : isInvalid == true
                ? Icon(Icons.close, color: Colors.red)
                : null,
      ),
    );
  }
}
