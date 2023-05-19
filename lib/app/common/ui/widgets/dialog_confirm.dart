import 'package:flutter/material.dart';

import 'custom_loading.dart';

class DialogConfirm extends StatefulWidget {
  final String title;
  final String content;
  final String textButton;
  final VoidCallback? onPressed;

  const DialogConfirm({
    Key? key,
    required this.title,
    required this.content,
    required this.textButton,
    this.onPressed,
  }) : super(key: key);

  @override
  State<DialogConfirm> createState() => _DialogConfirmState();
}

class _DialogConfirmState extends State<DialogConfirm> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: SizedBox(
            height: 170,
            width: 280,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CustomLoading(),
              ),
            ),
          ))
        : SizedBox(
            width: double.infinity,
            child: AlertDialog(
              title: Text(widget.title),
              content: Text(widget.content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    return widget.onPressed!();
                  },
                  child: Text(widget.textButton),
                ),
              ],
            ),
          );
  }
}
