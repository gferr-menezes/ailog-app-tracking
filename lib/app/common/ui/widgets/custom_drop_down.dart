import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropDown extends StatefulWidget {
  final String label;
  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropDown({super.key, required this.label, required this.items, this.onChanged, this.validator});

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      //height: 50,
      child: DropdownButtonFormField(
        items: widget.items,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          isDense: true,
          labelText: widget.label,
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
      ),
    );
  }
}
