import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final List<Widget>? actions;

  CustomDialog({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: WHITE,
        title: Text(
          widget.title,
          style: TextStyle(color: BLACK),
        ),
        content: Text(widget.content),
        actions: widget.actions);
  }
}
