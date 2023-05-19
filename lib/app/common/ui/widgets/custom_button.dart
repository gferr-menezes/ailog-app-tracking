import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButtom extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final bool loading;

  const CustomButtom({
    Key? key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.color,
    this.loading = false,
  }) : super(key: key);

  @override
  State<CustomButtom> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButtom> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height ?? 40,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          //shape: const StadiumBorder(),
          backgroundColor: widget.color,
        ),
        child: widget.loading == true
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: context.theme.primaryColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
