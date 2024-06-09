import 'package:a3d/api/index.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/components/Snackbar.dart';
import 'package:flutter/material.dart';

Future<void> processLogin(BuildContext context, String email, String password) async {
  Map<String, String> formData = {
    'email': email,
    'password': password,
  };
  
  try {
    final response = await httpClient.post("/login", formData);
    print(response.body);

    if (response.statusCode == 200) {
      showSuccessSnackbar(context, "Login successful!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Navbar()),
      );
    } else {
      showErrorSnackbar(context, "Login failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during login: $e");
  }
}
