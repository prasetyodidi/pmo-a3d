import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // Validation function

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator, // Validator added here
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: BLACK),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: BLACK),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: GREY),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with radius 10
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: RED),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with radius 10
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: BLACK),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with radius 10
          ),
          focusedErrorBorder:OutlineInputBorder(
            borderSide: BorderSide(color: RED),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with radius 10
          ), 
        ),
        validator: validator, // Validator function added here
      ),
    );
  }
}
