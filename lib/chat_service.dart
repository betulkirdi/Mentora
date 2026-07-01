import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatService {
  // Bilgisayarında çalışacak lokal FastAPI sunucunun varsayılan adresi
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000', 
      connectTimeout: const Duration(seconds: 15), // Katmanlı hata yönetimi için zaman aşımı
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

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