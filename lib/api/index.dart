import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  final String baseUrl;
  final Duration timeoutDuration = Duration(seconds: 7);

  HttpClient(this.baseUrl);

  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url).timeout(timeoutDuration);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> post(String endpoint, Map<String, String> fields, {List<http.MultipartFile>? files}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    print(url);
    final request = http.MultipartRequest('POST', url)
      ..fields.addAll(fields);

    if (files != null) {
      request.files.addAll(files);
    }
    
    final streamedResponse = await request.send().timeout(timeoutDuration);
    final response = await http.Response.fromStream(streamedResponse);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, String> fields, {List<http.MultipartFile>? files}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('PUT', url)
      ..fields.addAll(fields);

    if (files != null) {
      request.files.addAll(files);
    }
    
    final streamedResponse = await request.send().timeout(timeoutDuration);
    final response = await http.Response.fromStream(streamedResponse);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(url).timeout(timeoutDuration);
    _handleResponse(response);
    return response;
  }

  void _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'Request failed with status: ${response.statusCode}, body: ${response.body}',
      );
    }
  }
}

// Deklarasi variabel client secara global
final httpClient = HttpClient('http://192.168.18.8:1876/api');


class Prefs {
  static getUid() async { 
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int uid = prefs.getInt("uid")!;
    print("uiddddd ${uid}");
    return uid;
  }
}