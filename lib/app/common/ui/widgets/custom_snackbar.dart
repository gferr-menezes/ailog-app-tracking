import 'package:flutter/material.dart';

class CustomSnackbar {
  CustomSnackbar._();

  static CustomSnackbar configure() {
    return CustomSnackbar._();
  }

  static void show(BuildContext context, {required String message, Color? backgroundColor, Color? textColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? Colors.black,
        duration: const Duration(
          seconds: 3,
        ),
        content: SizedBox(
          height: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
