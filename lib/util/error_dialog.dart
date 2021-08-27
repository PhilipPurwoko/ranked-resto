import 'package:flutter/material.dart';

void showError(BuildContext ctx, String errorText) {
  showDialog(
    context: ctx,
    builder: (BuildContext bc) => AlertDialog(
      title: const Text('An Error Occured'),
      content: Text('$errorText. Please check your internet connection.'),
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
