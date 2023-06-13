import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_button.dart';

class ErrorPermission extends StatefulWidget {
  final Function callback;
  final String message;

  const ErrorPermission({required this.callback, required this.message, Key? key}) : super(key: key);

  @override
  State<ErrorPermission> createState() => _ErrorPermissionState();
}

class _ErrorPermissionState extends State<ErrorPermission> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/19_Error.png', fit: BoxFit.cover, height: context.height),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Permissão necessária',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black54,
              ),
            ),
            Text(
              widget.message,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black45,
              ),
              textAlign: TextAlign.center,
            ).paddingSymmetric(vertical: 8, horizontal: 40),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: CustomButtom(
                label: 'Tentar novamente',
                height: 50,
                width: context.width * 0.95,
                onPressed: () {
                  widget.callback();
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
