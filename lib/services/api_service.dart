// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your API host. If testing on Android emulator, use 10.0.2.2
  // For iOS simulator use 127.0.0.1. For a real device, use your PC's LAN IP.
  static const String _baseUrl = String.fromEnvironment('ASTRA_API_URL',
      defaultValue:
          //  'http://192.168.1.2:5000'); // use 10.0.2.2 for Android emulator
          //'http://10.242.43.98:5000');
          'http://10.84.71.98:5000');

  static Future<Map<String, dynamic>> analyzeImage(File imageFile) async {
    final url = Uri.parse('$_baseUrl/predict_image');

    try {
      var request = http.MultipartRequest('POST', url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      var response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        final errorText = await response.stream.bytesToString();
        throw Exception("Server error: $errorText");
      }

      final responseData = await response.stream.bytesToString();
      return jsonDecode(responseData);
    } on SocketException {
      throw Exception('No network connection.');
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: ${e.message}');
    }
  }

  /// Sends `text` to /predict and returns decoded JSON map.
  /// Throws an exception on network error or non-200 response.
  static Future<Map<String, dynamic>> analyzeText(String text,
      {double? threshold}) async {
    final url = Uri.parse('$_baseUrl/predict');

    final body = <String, dynamic>{'text': text};
    if (threshold != null) {
      body['threshold'] = threshold;
    }

    try {
      final resp = await http
          .post(url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body))
          .timeout(const Duration(seconds: 10)); // timeout

      if (resp.statusCode != 200) {
        // try to decode an error message if available
        String message = 'Server returned ${resp.statusCode}';
        try {
          final decoded = jsonDecode(resp.body);
          if (decoded is Map && decoded.containsKey('error')) {
            message = decoded['error'].toString();
          } else {
            message = resp.body;
          }
        } catch (_) {}
        throw HttpException(message);
      }

      final Map<String, dynamic> decoded = jsonDecode(resp.body);
      return decoded;
    } on SocketException {
      throw Exception('No network connection. Please check your internet.');
    } on FormatException {
      throw Exception('Bad response format from server.');
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: ${e.message}');
    }
  }
}
