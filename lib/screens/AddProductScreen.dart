import 'dart:io';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/CustomTextField.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/api/impl/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a3d/components/ImagePicker.dart';
import 'package:a3d/constants/index.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  XFile? _productImage;
  bool isLoading = false;
  @override
  void dispose() {
    // Clear text controllers and image variable when the screen is disposed
    _nameController.dispose();
    _priceController.dispose();
    _productImage = null;
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BACKGROUND,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.chevron_left, color: GREY, size: 35),
        ),
        title: CustomText(
          text: "Tambah Produk Baru",
          textStyle: TextStyle(
            color: GREY,
            fontSize: BIG_TITLE_FONTSIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: BACKGROUND,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Text Field: Product Name
              CustomTextField(
                labelText: 'Nama Produk',
                controller: _nameController,
                obscureText: false,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk Wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 6),
              // Text Field: Price
              CustomTextField(
                labelText: 'Harga',
                controller: _priceController,
                obscureText: false,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga Wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              // Image Picker
              InkWell(
                onTap: () async {
                  XFile? image = await showImagePicker(context);
                  setState(() {
                    _productImage = image;
                  });
                },
                child: Container(
                  child: _productImage == null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Icon(Icons.add_photo_alternate_sharp, size: 50),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                        )
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                            File(_productImage!.path),
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.width,
                          
                          ),
                      ),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 24, left: 12, right: 12, top: 6),
        child: CustomButton(
          text: isLoading ? "..." : "Simpan",
          onPressed: () {
            if (isLoading) return;
            setState(() {
              isLoading = true;
            });
            if (!_formKey.currentState!.validate())
              return; // Check if the form is valid
            processAddProduct(context, _nameController.text,
                    _priceController.text, _productImage!)
                .then((val) {
              setState(() {
                isLoading = false;
              });
            });
          },
        ),
      ),
    );
  }
}
