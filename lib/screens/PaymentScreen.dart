import 'dart:io';

import 'package:a3d/api/impl/auth.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/CustomTextField.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a3d/components/ImagePicker.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({super.key, required this.name});
  String name;
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _summaryController = TextEditingController();
  bool isLoadingRegister = false;
  XFile? _paymentImage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Block the back button press
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Logo
                  Container(
                    child: Image.asset(
                      'assets/LOGO.png',
                      width: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ),
                  // Text
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    child: CustomText(
                        text: "Pembayaran Pendaftaran",
                        textStyle: TextStyle(
                            fontSize: TITLE_FONTSIZE,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    child: CustomText(
                        text:
                            "Halo ${widget.name}!, Silahkan bayar terlebih dahulu untuk"),
                    margin: EdgeInsets.only(bottom: 24, top: 12),
                  ),
                  // summary TextField
                  CustomTextField(
                    labelText: 'Atas Nama',
                    controller: _summaryController,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Atas Nama Wajib diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Logo Upload
                  Container(
                    child: _paymentImage == null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, size: 50),
                          )
                        : Image.file(
                            File(_paymentImage!.path),
                            width: MediaQuery.of(context).size.width,
                          ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  CustomButton(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    text: 'Upload Bukti Pembayaran',
                    onPressed: () async {
                      XFile? image = await showImagePicker(context);
                      setState(() {
                        _paymentImage = image;
                      });
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Register Button
                  CustomButton(
                    text: isLoadingRegister ? '...' : 'Register',
                    onPressed: () {
                      if (isLoadingRegister ||
                          !_formKey.currentState!.validate())
                        return; // Check if the form is valid
                      setState(() {
                        isLoadingRegister = true;
                      });
                      processUploadPayment(
                              context, _summaryController.text, _paymentImage!)
                          .then((onValue) {
                        setState(() {
                          isLoadingRegister = false;
                        });
                      });
                    },
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: "Sudah memiliki akun?"),
                      SizedBox(
                        width: 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => LoginScreen()));
                        },
                        child: CustomText(
                            text: "Login",
                            textStyle: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
