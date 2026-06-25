import 'package:flutter/material.dart';
import 'register_page.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

void main() {
 runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mentora',
      debugShowCheckedModeBanner: false, // Sağ üstteki kırmızı "DEBUG" şeridini kaldırır
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- KİMLİK DOĞRULAMA HAFIZA ARAÇLARI ---
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Göz yormayan temiz arka plan
      body: SafeArea( // iOS batarya/saat çentiğinden (notch) tasarımı otomatik korur
        child: Center(
          child: SingleChildScrollView( // Klavye açılınca ekranın taşmasını ve hata vermesini önler
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Sağdan soldan 24 piksellik eşit koruma boşluğu
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                // --- 1. ÜST ALAN: MİNİMALİST APP LOGOSU ---
                // Karmaşık maskeleme kodları silindi, tertemiz oldu:
            // --- 1. ÜST ALAN: YATAY MARKA LOGOSU VE İSİM ---
               // --- 1. ÜST ALAN: YATAY MARKA LOGOSU VE İSİM ---
Row(
  mainAxisAlignment: MainAxisAlignment.center, 
  crossAxisAlignment: CrossAxisAlignment.center, // İkon ve yazıyı dikeyde kusursuz hizalar
  children: [
    // 1. Parça: Küçültülmüş ve dengelenmiş ikon
    Image.asset(
      'assets/images/logo.png',
      width: 36,  // İkonu 48'den 36'ya düşürdük
      height: 36, // Tam "M" harfinin yüksekliğine denk gelecek
      fit: BoxFit.contain,
    ),
    
    const SizedBox(width: 12), // İkon ile yazı arasındaki yatay boşluk
    
    // 2. Parça: Asil Mentora Yazısı
    const Text(
      'Mentora',
      style: TextStyle(
        fontSize: 36, // İkon 36, yazı 36 -> Kusursuz denge
        fontWeight: FontWeight.w800, // Yazıyı biraz daha dolgunlaştırdık (Extra Bold)
        color: Colors.indigo, 
        letterSpacing: -0.5, 
        height: 1.0, // Yazının etrafındaki görünmez boşluğu sıfırlar, ikonla milimetrik hizalar
      ),
    ),
  ],
),
                    const SizedBox(height: 50),

                // --- 2. ORTA ALAN: KİMLİK DOĞRULAMA (E-posta ve Şifre) ---
                TextField(
                  controller: _emailController,
                   decoration: InputDecoration(
                    labelText: 'E-posta Adresi',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.indigo),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.indigo),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- 3. ALT ALAN: AKSİYON BUTONLARI ---
                ElevatedButton(
                  onPressed: () {
                    final String email = _emailController.text.trim();
                    final String password = _passwordController.text;

                    debugPrint('Giriş yapma isteği: $email, şifre girildi mi: ${password.isNotEmpty}');

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Kimlik doğrulanıyor... E-posta: $email')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  child: const Text('Giriş Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Registerpage()),
                    );
                  },
                  child: const Text(
                    'Hesabın yok mu? Yeni bir hesap oluştur',
                    style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}