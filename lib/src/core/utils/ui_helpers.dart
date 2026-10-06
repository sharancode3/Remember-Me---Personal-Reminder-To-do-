import 'package:flutter/material.dart';

/// Converts common exception strings into clean, user-facing error text.
String readableError(Object error) => error
    .toString()
    .replaceFirst('Bad state: ', '')
    .replaceFirst('Exception: ', '');

/// Shows a standard transient snackbar message across the application.
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
