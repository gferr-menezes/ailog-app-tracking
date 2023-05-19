import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final String message;

  const CustomLoading({Key? key, this.message = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 10),
        Text(message != '' ? message : ''),
      ],
    );
  }
}
