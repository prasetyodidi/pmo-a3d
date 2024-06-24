import 'dart:io';
import 'package:a3d/api/impl/auth.dart';
import 'package:a3d/components/CustomButton.dart';
import 'package:a3d/components/CustomText.dart';
import 'package:a3d/components/CustomTextField.dart';
import 'package:a3d/constants/index.dart';
import 'package:a3d/screens/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoadingUpdateProfile = false;
  bool isLoading = false;
  XFile? _storeLogo;
  ProfileModel profile = ProfileModel(id: 1, name: "name", email: "email", phone: "phone", address: "address");

  @override
  void initState() {
    super.initState();
    // Fetch products from API when screen initializes
    _getProfile();
  }

  void _getProfile() {
    processGetProfile(context).then((val) {
      setState(() {
        // profile.id = val.id;
        // profile.name = val.name;
        // profile.email = val.email;
        // profile.phone = val.phone;
        // profile.address = val.address;
        _nameController.text = val.name;
        _emailController.text = val.email;
        _phoneController.text = val.phone;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: WHITE,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => LoginScreen()));
          },
          child: Icon(Icons.chevron_left, color: Colors.black, size: 35),
        ),
        title: CustomText(
          text: "Profil Kamu",
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: BIG_TITLE_FONTSIZE,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: isLoading
            ? Text("on loading...")
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: 'Nama',
                        controller: _nameController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama Wajib diisi';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        labelText: 'Email',
                        controller: _emailController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email Wajib diisi';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        labelText: 'Nomor Telepon',
                        controller: _phoneController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor Telepon Wajib diisi';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        labelText: 'Alamat',
                        controller: _addressController,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat Wajib diisi';
                          }
                          return null;
                        },
                      ),
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
                      CustomButton(
                        text: isLoadingUpdateProfile ? '...' : 'Update',
                        onPressed: () {
                          if (isLoadingUpdateProfile ||
                              !_formKey.currentState!.validate()) return;
                          setState(() {
                            isLoadingUpdateProfile = true;
                          });
                          processUpdateProfile(
                                  context,
                                  _emailController.text,
                                  _passwordController.text,
                                  _nameController.text,
                                  _addressController.text,
                                  _phoneController.text,
                                  _storeLogo!)
                              .then((v) {
                            setState(() {
                              isLoadingUpdateProfile = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
