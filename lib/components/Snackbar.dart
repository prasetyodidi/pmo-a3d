import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message, {int? seconds = 3}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,

  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackbar(BuildContext context, String message, {int? seconds = 3}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,

  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showInfoSnackbar(BuildContext context, String message, {int? seconds = 3}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.blue,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
