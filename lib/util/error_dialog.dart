import 'package:flutter/material.dart';

void showError(BuildContext ctx, String error) {
  showDialog(
    context: ctx,
    builder: (BuildContext bc) => AlertDialog(
      title: const Text('An Error Occured'),
      content: Text('$error. Please check your internet connection.'),
      actions: <TextButton>[
        TextButton(
          onPressed: () {
            Navigator.of(bc).pop();
          },
          child: const Text('Close'),
        )
      ],
    ),
  );
}
