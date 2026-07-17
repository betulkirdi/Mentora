
<p align="center">
<img src="mentora/assets/images/logo.png" width="100"/>
</p>

<h1 align="center">
🎓 Mentora
</h1>

<p align="center">
Yapay Zekâ Destekli Akademik Öğrenme Platformu
</p>

<p align="center">

Flutter • FastAPI • Firebase • Gemini • Ollama

</p>

<p align="center">

<img src="https://img.shields.io/badge/Flutter-3.x-blue">
<img src="https://img.shields.io/badge/FastAPI-Python-green">
<img src="https://img.shields.io/badge/Firebase-Cloud-orange">
<img src="https://img.shields.io/badge/Gemini-AI-red">
<img src="https://img.shields.io/badge/Ollama-LocalLLM-lightgrey">

</p>

## 📖 Proje Hakkında

**Mentora**, üniversite öğrencilerinin akademik öğrenme süreçlerini desteklemek amacıyla geliştirilmiş yapay zekâ destekli mobil bir öğrenme platformudur.

Platform; **Akademik Mentor**, **Fotoğraftan Adım Adım Soru Çözümü** ve **Topluluk (Social Learning)** modüllerini tek bir uygulamada bir araya getirerek öğrencilerin ders çalışma deneyimini daha verimli ve etkileşimli hâle getirmeyi amaçlamaktadır.

Uygulama; Flutter tabanlı mobil istemci, FastAPI ile geliştirilen backend servisi, Firebase bulut altyapısı ve Büyük Dil Modelleri (LLM) kullanılarak geliştirilmiştir. Sistem, yerel çalışan açık kaynak modelleri (Ollama) ile bulut tabanlı yapay zekâ servislerini (Google Gemini API) birlikte kullanabilen hibrit bir mimariye sahiptir.

Bu proje, üniversite stajım kapsamında **uçtan uca tarafımca tasarlanmış ve geliştirilmiştir.** Geliştirme sürecinde sistem mimarisi, mobil uygulama, backend servisleri, yapay zekâ entegrasyonları, veritabanı tasarımı ve performans optimizasyonu gibi yazılım geliştirme süreçleri tek geliştirici olarak yürütülmüştür.

---

# ✨ Temel Özellikler

## 🎓 Yapay Zekâ Akademik Mentor

Yapay zekâ destekli akademik danışman modülü sayesinde kullanıcılar; ders konuları, yazılım geliştirme, matematik ve mühendislik gibi alanlarda doğal dil kullanarak sorular sorabilir. Akademik Mentor, yalnızca cevap üretmek yerine öğrenciyi yönlendiren, açıklayan ve öğrenme sürecini destekleyen bir yaklaşım benimser.

---

## 📷 Fotoğraftan Soru Çözümü

Kullanıcılar çözemedikleri soruların fotoğraflarını uygulamaya yükleyebilir. Yapay zekâ; görseli analiz ederek matematiksel ifadeleri algılar, çözüm sürecini oluşturur ve sonucu Markdown ile LaTeX formatında adım adım sunar.

---

## 👥 Topluluk (Community)

Topluluk modülü sayesinde öğrenciler soru paylaşabilir, diğer kullanıcıların paylaşımlarını inceleyebilir, etkileşimde bulunabilir ve bilgi alışverişi yapabilir. Böylece bireysel öğrenmenin yanında sosyal öğrenme deneyimi de desteklenir.

---

## 📚 Çözüm Geçmişi

Yapay zekâ ile gerçekleştirilen soru çözümleri ve akademik mentor görüşmeleri kullanıcı hesabı ile ilişkilendirilerek saklanır. Kullanıcılar daha önce oluşturdukları içeriklere istedikleri zaman tekrar erişebilir.

---

## 🔐 Güvenli Kullanıcı Yönetimi

Firebase Authentication altyapısı kullanılarak kullanıcı kayıt, giriş ve oturum yönetimi güvenli bir şekilde gerçekleştirilmiştir.

---

# 📱 Uygulama Ekran Görüntüleri

<p align="center">
  <img src="docs/login.png" width="200" alt="Giriş">
  <img src="docs/homepage.png" width="200" alt="Ana Sayfa">
  <img src="docs/mentor.png" width="200" alt="Akademik Mentor">
</p>

<p align="center">
  <img src="docs/question.png" width="200" alt="Soru Çözümü">
  <img src="docs/community.png" width="200" alt="Topluluk">
  <img src="docs/history.png" width="200" alt="Geçmiş">
</p>

---

# 🏛️ Sistem Mimarisi

Mentora; Flutter ile geliştirilen mobil istemci, FastAPI tabanlı backend servisi, Firebase bulut altyapısı ve hibrit yapay zekâ katmanından oluşan modüler bir mimariye sahiptir.

Sistem, istemci ve sunucu katmanlarını birbirinden bağımsız olacak şekilde tasarlanmıştır. Bu sayede uygulamanın ölçeklenebilirliği artırılmış, bakım ve yeni özellik geliştirme süreçleri kolaylaştırılmıştır.

```mermaid
flowchart TD

A["📱 Flutter Mobil Uygulama"]

A --> B["⚙️ FastAPI Backend"]

B --> C["AI Servisi"]

C --> D["Ollama"]

C --> E["Google Gemini API"]

B --> F["Firebase Authentication"]

B --> G["Cloud Firestore"]
```
---

# 🤖 Yapay Zekâ İş Akışı

Fotoğraftan soru çözümü özelliği aşağıdaki işlem adımlarını takip eder.

```mermaid
flowchart LR

A["📷 Soru Görseli"]

--> B["Google Gemini Vision"]

--> C["Görsel Analizi"]

--> D["Adım Adım Çözüm"]

--> E["Markdown + LaTeX"]

--> F["Flutter Arayüzü"]
```
# 🛠️ Kullanılan Teknolojiler

| Katman | Teknoloji |
|---------|-----------|
| Mobil Uygulama | Flutter, Dart |
| Backend | Python, FastAPI |
| Yapay Zekâ | Google Gemini API, Ollama |
| Veritabanı | Cloud Firestore |
| Kimlik Doğrulama | Firebase Authentication |
| Durum Yönetimi | Provider |
| API Mimarisi | REST API |
| Sürüm Kontrol | Git, GitHub |

# 👩‍💻 Geliştirici

**Betül Kırdı**

Bilgisayar Mühendisliği Öğrencisi

Yapay zekâ, mobil uygulama geliştirme ve backend sistemleri üzerine çalışmalar yürütüyorum.

- LinkedIn:www.linkedin.com/in/betülkırdı
- Medium:https://medium.com/@betulkirdi




