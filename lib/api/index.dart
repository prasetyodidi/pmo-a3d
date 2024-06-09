import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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

  Future<http.Response> post(String endpoint, Map<String, String> fields) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', url)
      ..fields.addAll(fields);
    
    final streamedResponse = await request.send().timeout(timeoutDuration);
    final response = await http.Response.fromStream(streamedResponse);
    _handleResponse(response);
    return response;
  }

  Future<http.Response> put(String endpoint, Map<String, String> fields) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('PUT', url)
      ..fields.addAll(fields);
    
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
final httpClient = HttpClient('https://192.168.18.8:1876/api');
