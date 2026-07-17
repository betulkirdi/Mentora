import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ChatService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  Future<Map<String, dynamic>> sendPhotoToAI(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final response = await _dio.post(
        '/api/photo-solution',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Sunucu hatası: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Fotoğraf gönderilirken hata oluştu: $e");
    }
  }

  Future<String> sendMessageToAI(String message, String? email, String moduleType) async {
    try {
      final response = await _dio.post(
        '/api/chat',
        data: {
          'message': message,
          'email': email ?? 'anonim_user',
          'module_type': moduleType, 
        },
      );

      if (response.statusCode == 200) {
        return response.data['response'] ?? 'Boş yanıt döndü.';
      } else {
        return 'Sunucu hatası: ${response.statusCode}';
      }
    } on DioException catch (e) {
      debugPrint('Dio Ağ Hatası: ${e.message}');
      throw Exception('Yapay zekâ sunucusuna ulaşılamadı. Lütfen sunucunuzun açık olduğundan emin olun.');
    }
  }
}
