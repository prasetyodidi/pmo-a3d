// Function to convert base64 string to XFile
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

XFile? base64StringToXFile(String? base64String) {
  try {
    if (base64String != null) {
      Uint8List bytes = base64Decode(base64String);
      String tempPath = '${Directory.systemTemp.path}/${DateTime.now().toIso8601String()}.png';
      File tempFile = File(tempPath);
      tempFile.writeAsBytesSync(bytes);
      return XFile(tempPath);
    }
  } catch (e) {
    print(e);
    return null;
  }
}