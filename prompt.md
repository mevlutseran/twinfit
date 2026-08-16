# MASTER KICKOFF PROMPT: TWINFIT (BİYOLOJİK İKİZ & OTONOM ALTIN ROTA FİTNESS EKOSİSTEMİ)

⚠️ KRİTİK GÖREV TALİMATI (FROZEN STATE):
Şu an KESİNLİKLE hiçbir araç kullanma (Tool/Terminal çalıştırma), dosya oluşturma, klasör açma veya GitHub'a bağlanma. Şu an sadece bir "Kurumsal Yazılım Mimarı ve CPO" olarak okuma, analiz ve planlama modundasın. Ben sana açıkça "KODLAMAYA BAŞLA" komutunu vermeden tek bir satır bile kod yazamazsın ve dosya oluşturamazsın.

---

## 🔒 SERT KURALLAR VE YASALAR (STRICT LAWS)

1. **HARD ASK-HUMAN GATE (İNSAN ONAYI GEÇİDİ):**
   - Projeyi ve credentials durumunu analiz ettiğinde eksik bir şey görürsen (örneğin Supabase URL eksikliği, GitHub token yetersizliği, env değişkenleri vb.) asla varsayımda bulunma ve atlama.
   - Durumu bana raporla ve gerekli ayarlamaları yapmamı bekle. Ben onay vermeden asla ilerleme.
2. **SIFIR ATLAYIŞ & DETAYLI PLANLAMA:**
   - Projedeki TÜM sayfaları, modülleri ve akışları (Auth, Onboarding, Dashboard, TwinFit AI, Profil, Ayarlar vb.) en başta tam liste olarak planla.
   - Benim unuttuğum bir akış varsa sen ekle ve sistemi bir bütün haline getir.

---

## 🛠 TEKNİK ALTYAPI VE PROJE VİZYONU
- **Proje Adı / Domain:** TwinFit
- **Client (Mobile):** Flutter / Dart (Clean Architecture, BLoC/Riverpod)
- **Backend & Veritabanı:** Supabase (PostgreSQL)
- **Realtime / Cache:** WebSockets & Redis
- **Ortamlar:** Development (Lokal emülatörler), Production (Canlı)
- **Credential Kaynağı:** Proje kök dizinindeki `credentials.txt` dosyası.

---

## 📱 İSTENEN ÖZELLİKLER VE SAYFALAR (KAPSAM)

1. **Auth & Onboarding Akışı:** 
   - Login, Register, Forgot Password, Token Revoke, Biometrik Giriş (FaceID/TouchID).
   - Kullanıcıdan yaş, boy, kilo, hedef toplayan akıcı bir Onboarding ekranı.
2. **Dashboard / Biyolojik İkiz:** 
   - Gelişim, kalori/makro ve antrenman özet ekranı. Sonsuz kaydırma (infinite pagination) ve lazy load optimizasyonu.
3. **Otonom Antrenman & Altın Rota (Feed):** 
   - Günlük egzersiz kartları, set/tekrar ve dinlenme süreleri. Dikey görsellerde aspect-ratio (oran) koruması.
4. **TwinFit AI (Yapay Zeka Koç):** 
   - Haftalık sentetik ikiz raporları ve anlık koçluk chat ekranı. AI mesajlarında özel "AI Badge" rozeti.
5. **Profil & Portfolyo:** 
   - İstatistikler, başarı rozetleri, profil bilgileri güncelleme, şifre değiştirme, hesap silme ve detaylı bildirim tercihleri (Push/E-posta).
6. Projenin Genel Mantığı
    TwinFit, fitness dünyasında **"Dijital İkiz" (Digital Twin)** ve **"Otonom Altın Rota Motoru"** kavramlarını birleştiren ilk bütünleşik ekosistemdir.



TwinFit basit bir egzersiz takip uygulaması değil; kullanıcının fizyolojik kapasitesini anlık simüle eden, **saçma ve verimsiz programlarla 1 gün dahi vakit kaybettirmeyen, sıfır deneme-yanılma ile maksimum hipertrofi ve gücü hedefleyen otonom bir dijital koçtur.**



---



## 2. BİYOLOJİK İKİZLEME VE OTONOM "ALTIN ROTA" MİMARİSİ



TwinFit’in en temel kuralı ve varlık sebebi: **Kullanıcıya rastgele egzersiz seçtirmemek, biyolojik eşleşme ile doğrudan "Altın Rota"yı sunmaktır.**



> **[Kullanıcı Biyolojik Verisi] ➔ [Look-Alike / Sentetik Engine] ➔ [Biyomekanik Filtre] ➔ [Otonom Altın Rota Programı]**



### 2.1. Akıllı Egzersiz Kütüphanesi & Biyomekanik Etiketleme Mimarisi

Egzersiz kütüphanesi geleneksel uygulamalardaki gibi sadece "Göğüs" veya "Bacak" şeklinde yüzeysel kategorize edilmez. Kütüphanedeki her egzersiz derin biyomekanik parametrelerle etiketlenmiştir:



* **CNS (Merkezi Sinir Sistemi) Yük Skoru (1 - 10):** Hareketin sistemik yorgunluk yaratma potansiyeli. (Örn: Barbell Deadlift = 9/10, Lying Leg Curl = 3/10).

* **SFR (Stimulus-to-Fatigue Ratio - Uyarım/Yorgunluk Oranı):** Kas yapım uyarımı yüksek, yorgunluk etkisi düşük hareketlerin önceliklendirilmesi (Örn: Cable Lateral Raise yüksek SFR'a sahiptir).

* **Eklem Stres İndeksi:** Omuz, bel, diz ve dirsek gibi kritik eklemlere binen anlık ve kümülatif yük katsayısı.

* **Biyomekanik Açılar & Uzuv Uyum Verisi:** Kullanıcının femur/torso oranı, kol boyu ve eklem mobilitesine göre hareketin mekanik verimlilik skoru.



### 2.2. "Altın Rota" (Golden Path) Otonom Program Motoru

Algoritma, kullanıcının gelişimini rastgele deneme-yanılamalara asla bırakmaz:



1. **Cold Start (Sentetik İkizler):** Yeni başlayan ve henüz verisi birikmemiş bir kullanıcı için sistem, NSCA (National Strength and Conditioning Association) ve güncel spor bilimi meta-analiz verilerine dayanarak oluşturulmuş **"Sentetik (Bilimsel) İkiz"** modellerini çalıştırır. Kullanıcı, bilimin öngördüğü en yüksek verimli set/tekrar/frekans kombinasyonuyla işe başlar.

2. **Look-Alike (Fizyomimetik Eşleşme) Modellemesi:** Veri havuzu büyüdükçe gerçek insan rotaları devreye girer.

* *Çalışma Mantığı:* Sistem; Erkek 85 kg ağırlığında, %22 yağ oranına sahip, belirli uzuv boyu ve hipertrofi hedefi olan yeni bir erkek kullanıcı geldiğinde veritabanındaki geçmiş binlerce veri arasından **tıpatıp aynı başlangıç verilerine sahip olup en kısa sürede maksimum kas kütlesi / yağ kaybı elde etmiş ilk %10'luk "Altın İnsan" kümesini** bulur.

* *Otonom Atama:* Sistem bu başarılı kitlenin uyguladığı egzersiz sıralamasını, ağırlık artış hızını (progressive overload) ve dinlenme sürelerini kütüphaneden çekerek yeni kullanıcının önüne **"Otonom Altın Rota Programı"** olarak koyar.

3. **Maksimum Gelişim Garantisi:** Kullanıcı "Acaba bu hareket bana faydalı mı?" şüphesi yaşamaz. Algoritma, onunla aynı biyolojiye sahip insanların başardığı kanıtlanmış en hızlı rotayı otonom olarak işletir. 
---

## 🎨 TASARIM VE MİMARİ STANDARTLAR
- Mobil Native standartlarında, Linear.app ve Apple Health tarzını harmanlayan kusursuz Dark/Light tema desteği.
- Design System mantığıyla `components/` altında modüler ve düzenli reusable bileşenler.
- Skeleton loader ve optimistik UI güncellemeleri.

---

## 🎯 BEKLENEN ÇIKTI (ŞU AN YAPMAN GEREKEN)

Yukarıdaki tüm projeyi, sayfaları ve kuralları hafızana kaydet. Şimdi sadece metin tabanlı olarak şu iki adımı uygula:
1. `credentials.txt` dosyasından veya sistemden okuman/kontrol etmen gereken eksik bir şey olup olmadığını denetle, eksikleri bana maddeler halinde sor.
2. Mimariyle ilgili bana sorman gereken kritik sorular varsa sor.

Yanıtının sonuna mutlaka şu cümleyi ekle ve bekle:
**"Analiz tamamlandı. Eksikleri giderip bana 'KODLAMAYA BAŞLA' dediğinizde detaylı github issue'ları oluşturup projeyi inşa etmeye başlayacağım."**