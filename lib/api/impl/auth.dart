import 'dart:convert'
import 'package:a3d/api/index.dart';
import 'package:a3d/components/Navbar.dart';
import 'package:a3d/components/Snackbar.dart';
import 'package:a3d/screens/LoginScreen.dart';
import 'package:a3d/screens/PaymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> processLogin(
    BuildContext context, String email, String password) async {
  Map<String, String> formData = {
    'email': email,
    'password': password,
    'db': 'pmo'
  };

  try {
    final response = await httpClient.post(
      "/login",
      formData,
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      if (responseBody['status']) {
        // Extract session_id from cookies
        String? rawCookie = response.headers['set-cookie'];
        print("rawCok ${rawCookie}");
        if (rawCookie != null) {
          int index = rawCookie.indexOf(';');
          String sessionId =
              (index == -1) ? rawCookie : rawCookie.substring(0, index);

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("uid", responseBody['data']['uid']);
          prefs.setString("nama", responseBody['data']['name']);
          prefs.setString("email", responseBody['data']['username']);
          prefs.setString("session_id", sessionId); // Save session_id

          showSuccessSnackbar(context, "Berhasil Login!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Navbar()),
          );
        } else {
          showErrorSnackbar(context, "No session_id found in response cookies");
        }
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Login failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during login: $e");
  }
}

Future<void> processRegister(
    BuildContext context,
    String email,
    String password,
    String nama,
    String alamat,
    String noHp,
    XFile logo) async {
  Map<String, String> formData = {
    'email': email,
    'password': password,
    'name': nama,
    'address': alamat,
    'phone': noHp,
  };

  try {
    // Convert the XFile to MultipartFile
    final file = await http.MultipartFile.fromPath('image_1920', logo.path);

    // Send the post request with the file
    final response =
        await httpClient.post("/register", formData, files: [file]);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        var user_id = responseBody['data']['user_id'];
        prefs.setInt("user_id", user_id);
        prefs.setString("nama", nama);
        showSuccessSnackbar(
            context, "Daftar Berhasil, Sialhkan melakukan pembayaran!",
            seconds: 5);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentScreen(name: nama)),
        );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Register failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during register: $e");
  }
}

Future<void> processUploadPayment(
    BuildContext context, String summary, XFile image) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> formData = {
    'summary': summary,
    'user_id': prefs.getInt('user_id').toString(),
  };

  try {
    // Convert the XFile to MultipartFile
    final file = await http.MultipartFile.fromPath('image', image.path);

    // Send the post request with the file
    final response =
        await httpClient.post("/upload-payment", formData, files: [file]);
    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['status']) {
        prefs.remove("user_id");
        prefs.remove("nama");
        showSuccessSnackbar(context,
            "Terimakasih sudah mendaftar, Silahkan menunggu di verifikasi oleh Admin!",
            seconds: 5);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Register failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during register: $e");
  }
}

Future<void> processLogout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

class ProfileModel {
  int id;
  String name; 
  String email; 
  String phone; 
  String address;
  String? image;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      image: json['image'],
    );
  }

  Map<String, String> toJson() {
    return {
      'uid': id.toString(),
      'id': id.toString(),
      'name': name,
      'email': email.toString(),
      'phone': phone.toString(),
      'address': address.toString(),
      'image': image.toString(),
    };
  }
}

Future<ProfileModel> processGetProfile(BuildContext context) async {
  ProfileModel profile = ProfileModel(id: 1, name: "", email: "", phone: "", address: "");
  print("benerannnn ${await Prefs.getUid()}");
  try {
    final response = await httpClient
        .post("/self", {'uid': (await Prefs.getUid()).toString()});
    var responseBody = jsonDecode(response.body);
    print(responseBody);
    if (response.statusCode == 200) {
      profile.id = responseBody['data']['id'];
      profile.name = responseBody['data']['name'];
      profile.email = responseBody['data']['email'];
      profile.phone = responseBody['data']['phone'];
      profile.address = responseBody['data']['address'];
    } else {
      showErrorSnackbar(context, "Update Profile failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during Update Profile: $e");
  }
  return profile;
}

Future<void> processUpdateProfile(
    BuildContext context,
    String email,
    String password,
    String nama,
    String alamat,
    String noHp,
    XFile logo) async {
  Map<String, String> formData = {
    'email': email,
    'password': password,
    'name': nama,
    'address': alamat,
    'phone': noHp,
  };

  try {
    // Convert the XFile to MultipartFile
    final file = await http.MultipartFile.fromPath('image_1920', logo.path);

    // Send the post request with the file
    final response = await httpClient.post("/self", formData, files: [file]);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['status']) {
        showSuccessSnackbar(context, "Update Profile Berhasil!", seconds: 5);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentScreen(name: nama)),
        );
      } else {
        showErrorSnackbar(context, responseBody['message']);
      }
    } else {
      showErrorSnackbar(context, "Update Profile failed: ${response.body}");
    }
  } catch (e) {
    print(e);
    showErrorSnackbar(context, "Error during Update Profile: $e");
  }
}
