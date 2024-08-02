import 'package:flutter/material.dart';

Future<void> showMessageDialog(
  BuildContext context, 
  String text,
  ) {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Information!"),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
            }, 
              child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}