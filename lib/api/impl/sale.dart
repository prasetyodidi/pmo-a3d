import 'dart:convert';
import 'dart:io';

import 'package:a3d/api/index.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/components/Snackbar.dart';
import 'package:a3d/screens/LoginScreen.dart';
import 'package:a3d/screens/PaymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> processCreateSale(
    BuildContext context, Map<String, String> products, String date) async {
  var data = {'line_ids': products, 'date': date};
  Map<String, String> formData = {
    'uid': (await Prefs.getUid()).toString(),
    'data': jsonEncode(data).toString(),
  };

  try {
    final response = await httpClient.post("/login", formData);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        showSuccessSnackbar(context, "Berhasil Login!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Navbar()),
        );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Register failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during login: $e");
  }
}
