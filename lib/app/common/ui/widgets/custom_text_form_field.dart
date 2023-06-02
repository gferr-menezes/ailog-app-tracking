import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final void Function()? clearText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.clearText,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      cursorColor: context.theme.primaryColor,
      decoration: InputDecoration(
        suffixIcon: clearText != null
            ? IconButton(
                onPressed: clearText,
                icon: const Icon(Icons.clear),
              )
            : null,
        isDense: true,
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        errorStyle: const TextStyle(
          color: Colors.redAccent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
