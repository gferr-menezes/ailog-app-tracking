import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final String message;

  const NotFound({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/not_found.jpg',
          width: 250,
          height: 250,
        ),
        Text(
          message,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}
