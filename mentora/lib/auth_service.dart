import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // E-posta ve Şifre ile Firebase üzerinden Giriş Yapma Fonksiyonu
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user; // Giriş başarılıysa Firebase'in oluşturduğu kullanıcı nesnesini döner
    } on FirebaseAuthException catch (e) {
      // Firebase'den gelen karmaşık hata kodunu yakalayıp, bizim Türkçeleştirdiğimiz metoda paslıyoruz
      throw Exception(_mapErrorCode(e.code));
    }
  }

  // Hata Kodlarını Kullanıcının Anlayacağı Dile Çeviren Yardımcı Metot (Exception Handling)
  String _mapErrorCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı.';
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      case 'network-request-failed':
        return 'İnternet bağlantısını kontrol edin.';
      case 'too-many-requests':
        return 'Çok fazla deneme yapıldı. Biraz bekleyin.';
      case 'operation-not-allowed':
        return 'E-posta/şifre girişi şu anda aktif değil.';
      default:
        return 'Giriş başarısız oldu. Lütfen bilgilerinizi kontrol edin.';
    }
  }
}