import 'package:a3d/api/impl/auth.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/CustomTextField.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/PaymentScreen.dart';
import 'package:a3d/screens/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoadingLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      text: "Masuk",
                      textStyle: TextStyle(
                          fontSize: TITLE_FONTSIZE,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  child: CustomText(
                      text:
                          "Selamat Datang di aplikasi A3D, Kelola toko Anda semakin mudah!"),
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
                      return 'Email is required';
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
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                // Login Button
                CustomButton(
                  text: isLoadingLogin ? '...' : 'Login',
                  onPressed: () {
                    if (isLoadingLogin || !_formKey.currentState!.validate())
                      return; // Check if the form is valid
                    setState(() {
                      isLoadingLogin = true;
                    });
                    processLogin(context, _emailController.text,
                            _passwordController.text)
                        .then((val) {
                      setState(() {
                        isLoadingLogin = false;
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
                    CustomText(text: "Belum memiliki akun?"),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (prefs.getInt("user_id") != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => PaymentScreen(
                                        name: prefs.getString("nama")!,
                                      )));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => RegisterScreen()));
                        }
                      },
                      child: CustomText(
                          text: "Daftar",
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
