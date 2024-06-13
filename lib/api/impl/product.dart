import 'dart:convert';

import 'package:a3d/api/index.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/components/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ProductModel {
  final int id;
  final String name;
  final int price;
  final String? image;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.image,
  });

  // Factory constructor to create a ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
    );
  }

  // Method to convert a ProductModel to JSON
  Map<String, String> toJson() {
    return {
      'uid': id.toString(),
      'name': name,
      'price': price.toString(),
    };
  }
}

Future<List<ProductModel>> getAllProduct(BuildContext context) async {
  List<ProductModel> products = [];
  try {
    final response = await httpClient
        .post("/products/all", {'uid': (await Prefs.getUid()).toString()});
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (var product in responseBody['data']) {
        products.add(ProductModel(
            id: product['id'],
            name: product['name'],
            price: product['price'],
            image: product['image']));
      }
    } else {
      showErrorSnackbar(context, "Register failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during login: $e");
  }
  return products;
}

Future<void> processAddProduct(
    BuildContext context, String name, String price, XFile logo) async {
  Map<String, String> formData = ProductModel(
          id: await Prefs.getUid(), name: name, price: int.parse(price))
      .toJson();

  try {
    // Convert the XFile to MultipartFile
    final file = await http.MultipartFile.fromPath('image', logo.path);

    // Send the post request with the file
    final response =
        await httpClient.post("/products/create", formData, files: [file]);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        showSuccessSnackbar(context, "Berhasil Menambahkan Produk Baru",
            seconds: 5);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Navbar()),
              );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Internal Error");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error : $e");
  }
}

Future<void> processUpdateProduct(
    BuildContext context, String name, String price, XFile logo, int id) async {
  Map<String, String> formData = ProductModel(
          id: await Prefs.getUid(), name: name, price: int.parse(price))
      .toJson();

  try {
    // Convert the XFile to MultipartFile
    final file = await http.MultipartFile.fromPath('image', logo.path);

    // Send the post request with the file
    final response =
        await httpClient.post("/products/update/${id}", formData, files: [file]);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        showSuccessSnackbar(context, "Berhasil mengubah data produk",
            seconds: 5);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Navbar()),
              );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Internal Error");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error : $e");
  }
}


Future<void> processDeleteProduct(
    BuildContext context, int id) async {

  try {

    // Send the post request with the file
    final response =
        await httpClient.post("/products/delete/${id}", {'' : ''});
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        showSuccessSnackbar(context, "Berhasil menghapus data produk",
            seconds: 5);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Navbar()),
              );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Internal Error");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error : $e");
  }
}