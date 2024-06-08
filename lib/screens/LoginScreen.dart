import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/CustomTextField.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/constants/index.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
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
              child: CustomText(text: "Masuk", textStyle: TextStyle(fontSize: TITLE_FONTSIZE, fontWeight: FontWeight.bold)),
             ),
             Container(
              child: CustomText(text: "Selamat Datang di aplikasi A3D, Kelola toko Anda semakin mudah!"),
              margin: EdgeInsets.only(bottom: 24, top: 12),
             ),
              // Email TextField
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
              ),
              // Password TextField
              CustomTextField(
                labelText: 'Password',
                controller: _passwordController,
              ),
              SizedBox(height: 12,),
              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => Navbar()));
                },
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: "Belum memiliki akun?"),
                  SizedBox(width: 6,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => Navbar()));
                    },
                    child: CustomText(text: "Daftar", textStyle: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}