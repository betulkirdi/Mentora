import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart'; 

class AuthProvider extends ChangeNotifier {
  AuthProvider({FirebaseAuth? auth, FirebaseFirestore? firestore, AuthService? authService})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService ?? AuthService(); 

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AuthService _authService; /
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _auth.currentUser;

  ///  GİRİŞ YAPMA METODU 
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (email.trim().isEmpty) {
        return 'E-posta alanı boş olamaz.';
      }

      if (password.isEmpty) {
        return 'Şifre alanı boş olamaz.';
      }

      await _authService.signInWithEmailAndPassword(email, password);
      notifyListeners();

      return null; 
    } catch (e) {

      return e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///  KAYIT OLMA METODU 
  Future<String?> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (name.trim().isEmpty) {
        return 'Ad soyad boş olamaz.';
      }

      if (email.trim().isEmpty) {
        return 'E-posta boş olamaz.';
      }

      if (password.length < 8) {
        return 'Şifre en az 8 karakter olmalıdır.';
      }

      if (password != confirmPassword) {
        return 'Şifreler uyuşmuyor.';
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return _mapFirebaseAuthError(e.code);
    } catch (_) {
      return 'Kayıt olurken bir hata oluştu. Lütfen tekrar deneyin.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Bu e-posta zaten kullanılıyor.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'weak-password':
        return 'Şifre çok zayıf.';
      case 'operation-not-allowed':
        return 'E-posta/şifre girişi devre dışı.';
      default:
        return 'Kayıt başarısız oldu. Lütfen tekrar deneyin.';
    }
  }
}
