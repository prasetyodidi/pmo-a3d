import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: WHITE),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: BLACK),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: GREY),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with radius 10
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: BLACK),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with radius 10
          ),
        ),
      ),
    );
  }
}
