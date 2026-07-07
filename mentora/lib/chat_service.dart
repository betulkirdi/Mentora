import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ChatService {
  // Bilgisayarında çalışacak lokal FastAPI sunucunun varsayılan adresi
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<Map<String, dynamic>> sendPhotoToAI(File imageFile) async {
    try {
      // 1. Ham dosyayı multipart formatına dönüştürüyoruz
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // 2. Backend'deki yeni açtığımız endpoint'e POST isteği atıyoruz
      final response = await _dio.post(
        '/api/photo-solution',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      // 3. Backend'den dönen cevabı Map (JSON) olarak geri fırlatıyoruz
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Sunucu hatası: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Fotoğraf gönderilirken hata oluştu: $e");
    }
  }

  /// 💬 Kullanıcı mesajını FastAPI backend'e gönderir.
  /// [moduleType] parametresi sunucuya bu isteğin 'chat' (lokal) mi yoksa 'photo_solution' (bulut) mu olduğunu söyler.
  Future<String> sendMessageToAI(String message, String? email, String moduleType) async {
    try {
      // FastAPI backend'deki endpoint'imize istek atıyoruz
      final response = await _dio.post(
        '/api/chat',
        data: {
          'message': message,
          'email': email ?? 'anonim_user',
          'module_type': moduleType, // 💡 Sunucuya hangi LLM modelini seçeceğini fırlatıyoruz!
        },
      );

      if (response.statusCode == 200) {
        // Sunucudan dönen temiz yapay zekâ yanıtı
        return response.data['response'] ?? 'Boş yanıt döndü.';
      } else {
        return 'Sunucu hatası: ${response.statusCode}';
      }
    } on DioException catch (e) {
      debugPrint('Dio Ağ Hatası: ${e.message}');
      // Dokümanındaki "Katmanlı Hata Yönetimi" uyarısı için anlamlı hata fırlatıyoruz
      throw Exception('Yapay zekâ sunucusuna ulaşılamadı. Lütfen sunucunuzun açık olduğundan emin olun.');
    }
  }
}