import 'dart:convert';
import 'dart:io';

import 'package:a3d/api/impl/product.dart';
import 'package:a3d/api/index.dart';
import 'package:a3d/components/Snackbar.dart';
import 'package:a3d/screens/PreviewSaleScreen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Sale {
  final int id;
  final String date;
  final int total;
  final List<ProductCart> line_ids;

  Sale({
    required this.id,
    required this.date,
    required this.total,
    required this.line_ids,
  });

  // Convert a Sale instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'total': total,
      'line_ids': line_ids.map((product) => product.toJson()).toList(),
    };
  }

  // Create a Sale instance from a JSON object
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      date: json['date'],
      total: json['total'],
      line_ids: (json['line_ids'] as List)
          .map((product) => ProductCart.fromJson(product))
          .toList(),
    );
  }
}

Future<void> processCreateSale(BuildContext context,
    List<Map<String, String>> products, String date) async {
  var data = {'line_ids': products, 'date': date};
  Map<String, String> formData = {
    'uid': (await Prefs.getUid()).toString(),
    'data': jsonEncode(data).toString(),
  };

  try {
    final response = await httpClient.post("/sale/create", formData);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        showSuccessSnackbar(context, "Berhasil membuat penjualan!");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PreviewSaleScreen(sale_id: responseBody['data']['id'])),
        );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during login: $e");
  }
}

Future<void> downloadPDF(BuildContext context, int id) async {
  final response = await httpClient.get("/sale/pdf/${id}");

  if (response.statusCode == 200) {
    bool dirDownloadExists = true;
    var directory;
    if (Platform.isIOS) {
      directory = await getDownloadsDirectory();
    } else {
      directory = "/storage/emulated/0/Download/";

      dirDownloadExists = await Directory(directory).exists();
      if (dirDownloadExists) {
        directory = "/storage/emulated/0/Download/";
      } else {
        directory = "/storage/emulated/0/Downloads/";
      }
    }
    final String pathnya = '$directory/Penjualan-${id}.pdf';
    print(pathnya);
    // Tulis respons ke file PDF
    final pdfFile = File(pathnya);
    await pdfFile.writeAsBytes(response.bodyBytes);

    showSuccessSnackbar(context, "Berhasil mendwondload pdf");
  } else {
    showErrorSnackbar(context, 'Failed to load PDF');
  }
}

Future<Sale> processGetSaleById(BuildContext context, int id) async {
  Sale sale = Sale(date: "", id: 0, line_ids: [], total: 0);
  try {
    final response = await httpClient.post("/sale/${id}", {'': ''});
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        var data = responseBody['data'];
        List<dynamic> lineIdsData = data['line_ids'];
        List<ProductCart> lineIds = lineIdsData
            .map((product) => ProductCart.fromJson(product))
            .toList();
        sale = Sale(
            date: data['date'],
            id: data['id'],
            line_ids: lineIds,
            total: data['total']);
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during login: $e");
  }
  print("saaalae ${sale}");
  return sale;
}
