import 'dart:io';
import 'package:a3d/api/impl/auth.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/CustomTextField.dart';
import 'package:a3d/components/ImagePicker.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoadingRegister = false;
  XFile? _storeLogo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      text: "Daftar",
                      textStyle: TextStyle(
                          fontSize: TITLE_FONTSIZE, fontWeight: FontWeight.bold)),
                ),
                Container(
                  child: CustomText(
                      text:
                          "Selamat Datang di aplikasi A3D, Kelola toko Anda semakin mudah!, silahkan mendaftar untuk mendapatkan akses"),
                  margin: EdgeInsets.only(bottom: 24, top: 12),
                ),
                // Email TextField
                CustomTextField(
                  labelText: 'Email',
                  controller: _emailController,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Wajib diisi';
                    }
                    return null;
                  },
                ),
                // Password TextField
                CustomTextField(
                  labelText: 'Password',
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password Wajib diisi';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: 'Nama',
                  controller: _nameController,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Wajib diisi';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: 'Alamat',
                  controller: _addressController,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat Wajib diisi';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: 'Nomor HP',
                  controller: _phoneController,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor HP Wajib diisi';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                // Logo Upload
                Container(
                  child: _storeLogo == null
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50),
                        )
                      : Image.file(
                          File(_storeLogo!.path),
                          width: MediaQuery.of(context).size.width,
                        ),
                ),
                SizedBox(
                  height: 12,
                ),
                CustomButton(
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  text: 'Upload Logo',
                  onPressed: () async {
                    XFile? image = await showImagePicker(context);
                    setState(() {
                      _storeLogo = image;
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
                    if (isLoadingRegister || !_formKey.currentState!.validate()) return; // Check if the form is valid
                    setState(() {
                      isLoadingRegister = true;
                    });
                    // Registration logic
                    processRegister(context,  _emailController.text, _passwordController.text, _nameController.text, _addressController.text, _phoneController.text, _storeLogo!).then((v) {
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (builder) => LoginScreen()));
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
    );
  }
}
