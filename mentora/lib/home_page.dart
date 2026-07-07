import 'package:flutter/material.dart';
import 'chat_page.dart';
import 'photo_solution_page.dart'; // 💡 1. ADIM: Yeni sayfamızı buraya import ettik
import 'community_page.dart'; // 💡 Ek: Topluluk sayfasını import ettik

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. ÜST ALAN: HOŞ GELDİN PANELİ & ÇIKIŞ ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Merhaba 👋',
                        style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Mentora\'ya Hoş Geldin',
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.indigo.shade900,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    tooltip: 'Çıkış Yap',
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/'); 
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- 2. VURUCU MOTİVASYON KARTI ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.indigo.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akademik Asistanın Seni Bekliyor!',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Teorik konuları danışabilir, formüllü sorularının fotoğrafını çekebilir veya çalışma odasına katılabilirsin.',
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- 3. BÖLÜM BAŞLIĞI ---
              Text(
                'Öğrenme Modülleri',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo.shade900),
              ),
              const SizedBox(height: 16),

              // --- 4. MODÜLER AKSİYON KARTLARI ---
              // Modül 1: Yapay Zekâ Mentor
              _buildMenuCard(
                context,
                title: 'Yapay Zekâ Mentor',
                subtitle: 'Akademik danışman ile interaktif sohbet',
                icon: Icons.chat_bubble_outline_rounded,
                color: Colors.blue.shade50,
                iconColor: Colors.blue.shade700,
                onTap: () {
                  debugPrint('Yapay Zekâ Mentor Modülü tetiklendi.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatPage()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Modül 2: Fotoğraflı Soru Çözümü
              _buildMenuCard(
                context,
                title: 'Soru Çözümü',
                subtitle: 'Sorunun fotoğrafını çek, adım adım detaylı çözümü gör',
                icon: Icons.camera_alt_outlined,
                color: Colors.purple.shade50,
                iconColor: Colors.purple.shade700,
                onTap: () {
                  debugPrint('Soru Çözüm Modülü tetiklendi.');
                  // 💡 2. ADIM: Navigator ile yeni sayfaya köprüyü kurduk!
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PhotoSolutionPage()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Modül 3: Global Akran Topluluğu
              _buildMenuCard(
                context,
                title: 'Topluluk',
                subtitle: 'Diğer öğrencilerle anlık yardımlaş ve birlikte çalış',
                icon: Icons.groups_outlined,
                color: Colors.orange.shade50,
                iconColor: Colors.orange.shade700,
                onTap: () {
                  debugPrint('Topluluk Modülü tetiklendi.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CommunityPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle, 
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.2)
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 14),
          ],
        ),
      ),
    );
  }
}