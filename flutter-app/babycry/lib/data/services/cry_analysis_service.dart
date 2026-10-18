import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CryAnalysisService {
  // Emülatör için 10.0.2.2 kullanıyoruz.
  static const String baseUrl = "http://10.0.2.2:5000/api";

  static Future<bool> healthCheck() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status'] == 'healthy';
      }
      return false;
    } catch (e) {
      print("Bağlantı hatası: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Kategoriler alınamadı');
  }

  // analyzeMel metodu da benzer şekilde '$baseUrl/analyze/mel' kullanmalı
}
