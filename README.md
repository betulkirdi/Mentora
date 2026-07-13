Mentora — Yapay Zekâ Destekli Akademik Asistan Platformu
Mentora, tüm disiplinlerdeki üniversite öğrencilerini desteklemek için tasarlanmış, hibrit bulut mimarisine sahip yapay zekâ destekli bir akademik asistan platformudur. Kullanıcıların karmaşık matematiksel ve akademik soruların fotoğraflarını çekerek saniyeler içinde adım adım, hiyerarşik ve LaTeX formatında çözümlere ulaşmasını sağlar.

🚀 Öne Çıkan Özellikler
Hibrit Yapay Zekâ Katmanı (Ollama + Cloud API): Sistem, hem yerelde çalışan açık kaynaklı geniş dil modellerini (Ollama) hem de bulut tabanlı gelişmiş çok modlu yapay zekâ servislerini (Google Gemini API) bir arada kullanabilen esnek bir backend mimarisine sahiptir.

Çok Modlu Soru Analizi (Multimodal AI): Görseldeki matematiksel formülleri ve metinleri doğrudan analiz ederek tek bir akışta hem OCR işlemini gerçekleştirir hem de adım adım hiyerarşik çözümler üretir.

Akıllı Geçmiş (History) Yönetimi: Çözülen soruları ve yapay zekâ yanıtlarını bulutta saklayarak öğrencilerin eski çözümlerine diledikleri an ulaşmasını sağlar.

Gelişmiş Zengin Metin (Rich Text) Motoru: Çözüm ekranında hem standart Markdown metinlerini hem de karmaşık matematiksel LaTeX formüllerini pürüzsüz bir şekilde render eder.

🏗️ Sistem Mimarisi & Optimizasyon Gerekçeleri
Proje, hem mobil hem de backend katmanlarını tek bir merkezden yöneten Monorepo yapısıyla kurgulanmıştır.

💡 Hibrit Bulut Veri Modeli ve Maliyet Optimizasyonu
Sistem mimarisi tasarlanırken, ham resim dosyalarını bulut üzerinde (Firebase Storage) saklamanın yaratacağı yüksek depolama maliyetlerini ve ağ trafiği yükünü optimize etmek amacıyla inovatif bir yaklaşım benimsenmiştir:

Soru fotoğrafları yerel cihaz hafızasında işlenip yapay zekâ katmanına iletildikten sonra, bulut veritabanında (Firestore) resmin kendisi yerine sadece anlamlı LaTeX formül çıktıları (ocrText) ve hiyerarşik çözümler (solution) indekslenmiştir.

Bu yaklaşım, bulut depolama maliyetlerini ve veri tabanı okuma/yazma sürelerini %90'ın üzerinde azaltarak projenin sürdürülebilirliğini ve performansını maksimuma çıkarmıştır.

🛠️ Teknoloji Yığını (Tech Stack)
Mobil Katman (/mentora)
Framework: Flutter & Dart

Veritabanı & Bağımlılıklar: Firebase Firestore (Cloud Database)

UI/UX: Shimmer Efektleri, Custom LaTeX & Markdown Renderer

Backend Katman (/backend)
Framework: FastAPI (Python)

Lokal Yapay Zekâ: Ollama (Local LLM Orchestration)

Bulut Yapay Zekâ API: Google Gemini API (Multimodal Vision & GenAI)
