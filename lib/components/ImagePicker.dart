import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> showImagePicker(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();

  return await showModalBottomSheet<XFile?>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Gallery'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                Navigator.of(context).pop(image);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () async {
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                Navigator.of(context).pop(image);
              },
            ),
          ],
        ),
      );
    }
  );
}
