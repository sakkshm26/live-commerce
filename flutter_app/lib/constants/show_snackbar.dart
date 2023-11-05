import 'package:flutter/material.dart';

void showCustomSnackBar(
    {required BuildContext context, required String message, GlobalKey<ScaffoldMessengerState>? key}) {
  final snackBar = SnackBar(
    elevation: 20,
    content: Text(message),
    duration: const Duration(seconds: 4),
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'CLOSE',
      onPressed: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
      },
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  if (key != null) {
    key.currentState!.showSnackBar(snackBar);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
