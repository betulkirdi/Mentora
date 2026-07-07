import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityMessage {
  final String id;
  final String senderName;
  final String senderEmail;
  final String messageText;
  final DateTime createdAt;

  CommunityMessage({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.messageText,
    required this.createdAt,
  });

  // Firestore'dan gelen veriyi Dart nesnesine çeviren yapıcı metot
  factory CommunityMessage.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CommunityMessage(
      id: documentId,
      senderName: data['senderName'] ?? 'Anonim Öğrenci',
      senderEmail: data['senderEmail'] ?? '',
      messageText: data['messageText'] ?? '',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }
}