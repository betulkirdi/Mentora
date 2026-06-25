import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<String?> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    notifyListeners();

    if (name.trim().isEmpty) {
      _isLoading = false;
      notifyListeners();
      return 'Ad soyad boş olamaz.';
    }

    if (email.trim().isEmpty) {
      _isLoading = false;
      notifyListeners();
      return 'E-posta boş olamaz.';
    }

    if (password.length < 8) {
      _isLoading = false;
      notifyListeners();
      return 'Şifre en az 8 karakter olmalıdır.';
    }

    if (password != confirmPassword) {
      _isLoading = false;
      notifyListeners();
      return 'Şifreler uyuşmuyor.';
    }

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    return null;
  }
}