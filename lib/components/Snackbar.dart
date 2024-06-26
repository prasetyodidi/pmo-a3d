import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message, {int? seconds = 3}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: WHITE)),
    backgroundColor: RED,
    duration: Duration(seconds: 3),
    elevation: 0,
    behavior: SnackBarBehavior.floating,

  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackbar(BuildContext context, String message, {int? seconds = 3}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: WHITE)),
    backgroundColor: GREY,
    elevation: 0,
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
