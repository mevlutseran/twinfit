const { execSync } = require('child_process');

const milestones = [
  { title: "Milestone 1: Core Infrastructure & Design System", description: "Veritabanı, RLS politikaları, Upstash Redis ve Linear+Apple Health tasarım sistemi" },
  { title: "Milestone 2: Auth, Biometrics & Biological Onboarding", description: "Supabase Auth, Biyometrik FaceID/TouchID ve 4 adımlı Sentetik İkiz kurulumu" },
  { title: "Milestone 3: Dashboard & Digital Twin Cockpit", description: "Biyolojik İkiz kas haritası, CNS yük göstergesi ve günlük beslenme kokpiti" },
  { title: "Milestone 4: Autonomous Golden Path & Workout Runner", description: "Otonom Altın Rota motoru, Canlı Antrenman Yürütücü ve Akıllı Dinlenme Sayacı" },
  { title: "Milestone 5: Biomechanical Exercise Catalog", description: "CNS, SFR, Eklem Stres indeksli egzersiz kütüphanesi ve alternatif hareket motoru" },
  { title: "Milestone 6: TwinFit AI Coach & Synthetic Reports", description: "Biyometrik kontekstli AI koçluk sohbeti ve haftalık sentetik ikiz adaptasyon raporları" },
  { title: "Milestone 7: Analytics, Offline Sync & Profile Settings", description: "Hacim/1RM grafikleri, Offline-first Isar/Hive sync motoru, rozetler ve profil yönetimi" }
];

const issues = [
  {
    milestone: "Milestone 1: Core Infrastructure & Design System",
    title: "[Core] Supabase Veritabanı Şeması, RLS Güvenlik Politikaları & Tohum Veriler",
    body: `### Açıklama
Supabase üzerinde PostgreSQL tablolarının, RLS (Row Level Security) kurallarının ve 12+ derin biyomekanik etiketli egzersiz tohum verilerinin kurulumu.

### Kapsam
- [x] \`profiles\` tablosu (Biyolojik veriler, torso/femur, arm length, CNS kapasitesi)
- [x] \`exercises\` tablosu (CNS 1-10, SFR elite/high/medium/low, joint_stress_index JSON)
- [x] \`golden_path_routines\` & \`golden_path_exercises\` tabloları
- [x] \`workout_sessions\` & \`workout_set_logs\` tabloları
- [x] \`ai_coach_sessions\` & \`weekly_twin_reports\` tabloları
- [x] \`daily_nutrition_logs\` tablosu
- [x] RLS güvenlik politikaları
- [x] Biyomekanik tohum (seed) verileri migration dosyası ve veritabanına uygulanması`
  },
  {
    milestone: "Milestone 1: Core Infrastructure & Design System",
    title: "[Design System] Linear.app + Apple Health Dark/Light Tema & Atomik Bileşenler",
    body: `### Açıklama
Mobil native standartlarında, Linear.app ve Apple Health estetiğini harmanlayan koyu ve açık tema sistemi, atomik renk/tipografi tokenları ve yeniden kullanılabilir UI bileşenleri.

### Kapsam
- [ ] Atomik Renk Paleti (Cyber Green, Electric Cyan, Deep Charcoal, Glassmorphism efektleri)
- [ ] Typography Tokens (Inter / SF Pro esintili Google Fonts)
- [ ] Atomik UI Bileşenleri: TwinCard, TwinButton, TwinBadge (AI Rozeti dahil), TwinInputField
- [ ] Skeleton Loader & Shimmer bileşenleri
- [ ] Dynamic Theme Provider (Riverpod)`
  },
  {
    milestone: "Milestone 1: Core Infrastructure & Design System",
    title: "[Core Network] Supabase Client & Upstash Redis REST Entegrasyonu",
    body: `### Açıklama
Supabase Flutter SDK ve Upstash Redis REST API istemcisinin Clean Architecture katmanında konfigüre edilmesi ve servis sağlayıcılarının kurulması.

### Kapsam
- [ ] SupabaseClient başlatıcı & Singleton / Riverpod Provider
- [ ] Upstash Redis REST client (Önbellek, anlık durum, rate-limiting)
- [ ] Hata yakalama ve Global Exception Handler
- [ ] Local Storage (SharedPreferences & SecureStorage) servisleri`
  },
  {
    milestone: "Milestone 2: Auth, Biometrics & Biological Onboarding",
    title: "[Auth] Supabase Auth & Biyometrik Giriş (FaceID / TouchID)",
    body: `### Açıklama
Kullanıcı kayıt, giriş, şifre sıfırlama ve biyometrik (FaceID/TouchID) kimlik doğrulama kapısının inşası.

### Kapsam
- [ ] Splash Screen & Biyometrik Kontrol Geçidi
- [ ] Login & Register Ekranları
- [ ] Şifremi Unuttum (Forgot Password) Akışı
- [ ] Biyometrik Kimlik Doğrulama (LocalAuth) Entegrasyonu
- [ ] Session State & Token Refresh Yönetimi (Riverpod)`
  },
  {
    milestone: "Milestone 2: Auth, Biometrics & Biological Onboarding",
    title: "[Onboarding] 4 Adımlı Biyolojik Profiling & Sentetik İkiz (Cold Start)",
    body: `### Açıklama
Kullanıcıdan fiziksel ve biyomekanik verileri toplayan, NSCA bilimsel ilkeleriyle ilk "Sentetik İkiz" ve "Altın Rota" programını oluşturan interaktif onboarding akışı.

### Kapsam
- [ ] Adım 1: Fiziksel Metrikler (Yaş, cinsiyet, boy, kilo, yağ oranı)
- [ ] Adım 2: Biyomekanik & Morfoloji (Torso/Femur oranı, kol boyu, sakatlık/eklem geçmişi)
- [ ] Adım 3: Hedef & Kapasite (Hipertrofi/Güç/Rekompozisyon, haftalık gün sayısı)
- [ ] Adım 4: Sentetik İkiz Hesaplama ve Biyolojik İndeksleme Animasyonu
- [ ] İlk Otonom Altın Rota programının otomatik üretilmesi ve kaydedilmesi`
  },
  {
    milestone: "Milestone 3: Dashboard & Digital Twin Cockpit",
    title: "[Dashboard] Biyolojik İkiz Kokpiti, Kas Haritası & CNS Göstergesi",
    body: `### Açıklama
Kullanıcının fizyolojik durumunu, kas toparlanma yüzdelerini ve CNS (Merkezi Sinir Sistemi) yorgunluğunu görselleştiren merkezi kokpit ekranı.

### Kapsam
- [ ] Digital Twin Kas Haritası & Bölgesel Toparlanma Radarı
- [ ] CNS Yorgunluk & Kapasite Gösterge Kartı
- [ ] Günlük Beslenme & Su Dengesi Kartı (Kalori, Protein, Karb, Yağ, Su)
- [ ] Hızlı Su ve Kalori Güncelleme Modalı`
  },
  {
    milestone: "Milestone 3: Dashboard & Digital Twin Cockpit",
    title: "[Dashboard] 'Günün Altın Rotası' Hızlı Başlat Kartı & Sonsuz Aktivite Akışı",
    body: `### Açıklama
Kullanıcıya o gün yapması gereken en yüksek SFR'lı antrenmanı öneren dinamik kart ve geçmiş performans/aktivite akışı.

### Kapsam
- [ ] "Günün Altın Rotası" Hero Kartı (Tahmini süre, CNS etkisi, odak kaslar)
- [ ] "Antrenmana Başla" tek dokunuş aksiyonu
- [ ] Sonsuz Kaydırmalı (Infinite Pagination) Aktivite Geçmişi
- [ ] Lazy Load ve Skeleton Shimmer optimizasyonları`
  },
  {
    milestone: "Milestone 4: Autonomous Golden Path & Workout Runner",
    title: "[Golden Path] Otonom Altın Rota Program Motoru (Look-Alike Algoritması)",
    body: `### Açıklama
Kullanıcının biyolojik ikiz verilerine göre sıfır deneme-yanılma ile en yüksek hipertrofi getirisini sağlayan otonom program üretim motoru.

### Kapsam
- [ ] Biyomekanik Filtreleme (Uzuv oranlarına ve eklem stresine göre hareket eleme)
- [ ] SFR Maksimizasyonu & CNS Yük Dengeleme algoritması
- [ ] Haftalık Günlük Program Tablosu ve Detay Görüntüleme
- [ ] Manuel Müdahale & Akıllı Egzersiz Değiştirme (Substitute)`
  },
  {
    milestone: "Milestone 4: Autonomous Golden Path & Workout Runner",
    title: "[Workout Session] Canlı Antrenman Yürütücü & Akıllı Dinlenme Sayacı",
    body: `### Açıklama
Spor salonunda canlı antrenman takibi, set/tekrar/kilo loglama, RPE kaydı ve sesli/titreşimli akıllı dinlenme sayacı.

### Kapsam
- [ ] Canlı Oturum Başlatma & Süre Sayacı
- [ ] Set Loglama: Önceki Başarı | Hedef | Gerçekleşen Kilo | Tekrar | RPE
- [ ] Akıllı Dinlenme Sayacı (Rest Timer) — Dairesel sayaç, sesli/titreşimli uyarı
- [ ] Progressive Overload Rehberi (Son antrenmana göre otomatik öneri)
- [ ] Oturum Tamamlama Ekranı & CNS Yorgunluk Puanı Hesaplama`
  },
  {
    milestone: "Milestone 4: Autonomous Golden Path & Workout Runner",
    title: "[Workout Guide] Dikey Aspect-Ratio Korumalı Form Rehberi & İpuçları",
    body: `### Açıklama
Antrenman esnasında her egzersiz için dikey video/görsel rehberi ve biyomekanik püf noktaları sunan modal/sayfa.

### Kapsam
- [ ] Dikey Aspect-Ratio korumalı medya alanı
- [ ] Biyomekanik infografik ve hedef/sinerjist kas haritası
- [ ] Adım adım icra ipuçları (Execution Cues)
- [ ] Eklem güvenlik uyarıları ve kaçınılması gereken hatalar`
  },
  {
    milestone: "Milestone 5: Biomechanical Exercise Catalog",
    title: "[Catalog] Biyomekanik Egzersiz Kütüphanesi & Gelişmiş Filtreleme",
    body: `### Açıklama
Egzersizlerin CNS, SFR ve Eklem Stresi parametreleriyle listelendiği, filtrelendiği ve arandığı kütüphane modülü.

### Kapsam
- [ ] Arama ve Hızlı Filtre Barı (Kas Grubu, Ekipman)
- [ ] CNS Yük Skoru (1-10) ve SFR Filtresi (Elite, High, Medium)
- [ ] Eklem Dostu Filtreleme (Diz, Omuz, Bel hassasiyetine göre)
- [ ] Egzersiz Kartları ve Hızlı Detay Önizleme`
  },
  {
    milestone: "Milestone 5: Biomechanical Exercise Catalog",
    title: "[Catalog] Egzersiz Detayı & Akıllı Alternatif Hareket Önerici",
    body: `### Açıklama
Egzersizin tüm biyomekanik parametrelerini detaylandıran ve salondaki doluluk/ekipman durumuna göre aynı SFR profilindeki alternatif hareketleri öneren ekran.

### Kapsam
- [ ] Detaylı Anatomik Analiz & Eklem Stres Grafiği
- [ ] Biyomekanik Notlar & Uzuv Uyumluluk Puanı
- [ ] "Alternatif Hareket Öner" Algoritması (Aynı hedef kas & eşdeğer SFR)
- [ ] Tek dokunuşla antrenmana/rutine dahil etme`
  },
  {
    milestone: "Milestone 6: TwinFit AI Coach & Synthetic Reports",
    title: "[AI Coach] TwinFit AI Biyolojik Koç Chat Modülü & AI Rozeti",
    body: `### Açıklama
Kullanıcının antrenman geçmişini, biyometrik profilini ve yorgunluk seviyesini anlık kontekst olarak alan akıllı yapay zeka koçluk sohbeti.

### Kapsam
- [ ] TwinFit AI Sohbet Ekranı & "AI Badge" Rozeti
- [ ] Biyometrik Kontekst Enjeksiyonu (Profil, son antrenmanlar, beslenme)
- [ ] Hızlı Eylem Önerileri (Örn: "Bugün omzum ağrıyor, rotayı uyarla", "Platodayım ne yapmalıyım?")
- [ ] Gerçek Zamanlı Mesajlaşma Arayüzü & Akıcı UI`
  },
  {
    milestone: "Milestone 6: TwinFit AI Coach & Synthetic Reports",
    title: "[AI Reports] Haftalık Sentetik İkiz Gelişim & Adaptasyon Raporu",
    body: `### Açıklama
Yapay zekanın haftalık hacim artışını, toparlanma verimliliğini ve hipertrofi skorunu sentezleyerek sunduğu detaylı analitik rapor ekranı.

### Kapsam
- [ ] Hipertrofi İlerleme Skoru & Toparlanma Verimlilik İndeksi
- [ ] Hacim Artış Yüzdesi (Volume Progression) & CNS Yorgunluk Analizi
- [ ] AI Tarafından Üretilen Eyleme Dönüştürülebilir Tavsiyeler (Actionable Items)
- [ ] Deload Haftası Gerekip Gerekmediği Uyarısı`
  },
  {
    milestone: "Milestone 7: Analytics, Offline Sync & Profile Settings",
    title: "[Offline-First] Yerel Depolama & Arka Plan Senkronizasyon Motoru (Sync Queue)",
    body: `### Açıklama
Salonda veya internetsiz ortamlarda kullanıcının set kayıtlarını yerelde tutan ve internet geldiğinde Supabase ile senkronize eden optimistik senkronizasyon altyapısı.

### Kapsam
- [ ] Yerel Veri Depolama Servisi (SharedPreferences / Offline Cache)
- [ ] Senkronizasyon Kuyruğu (Sync Queue Engine)
- [ ] Ağ Durum Dinleyicisi (Connectivity Listener)
- [ ] Çakışma Yönetimi & Optimistik UI Güncellemeleri`
  },
  {
    milestone: "Milestone 7: Analytics, Offline Sync & Profile Settings",
    title: "[Analytics] Gelişim Analitiği, Hacim/1RM Projeksiyonları & Rozetler",
    body: `### Açıklama
Kullanıcının kaldırdığı toplam hacim, tahmini 1RM güç eğrileri, vücut kompozisyonu değişimleri ve kazanılan başarı rozetleri ekranı.

### Kapsam
- [ ] FL Chart ile Hacim Yükü (Volume Load) Trend Grafikleri
- [ ] Egzersiz Bazlı 1RM Güç İlerleme Eğrileri
- [ ] Vücut Ağırlığı & Yağ Oranı Projeksiyon Çizelgeleri
- [ ] Başarı Rozetleri & Milestone Ödülleri (Achievements Grid)`
  },
  {
    milestone: "Milestone 7: Analytics, Offline Sync & Profile Settings",
    title: "[Profile] Profil Yönetimi, Bildirim Ayarları & Hesap Silme",
    body: `### Açıklama
Kullanıcı biyolojik profil güncelleme, detaylı push/e-posta bildirim tercihleri, güvenlik/şifre yönetimi ve KVKK/GDPR uyumlu hesap silme ekranı.

### Kapsam
- [ ] Biyolojik Profil Bilgilerini Güncelleme Ekranı
- [ ] Detaylı Bildirim Tercihleri (Antrenman, Dinlenme, Raporlar)
- [ ] Biyometrik Giriş Aç/Kapat Ayarı
- [ ] Verileri Dışa Aktar (Export) & Hesap Silme (GDPR Delete Flow)
- [ ] Çıkış Yap (Sign Out & Clear Tokens)`
  }
];

async function run() {
  console.log("Creating Milestones on GitHub...");
  const milestoneMap = {};

  for (const m of milestones) {
    try {
      console.log(`Creating milestone: ${m.title}`);
      const res = execSync(`gh api repos/mevlutseran/twinfit/milestones -f title="${m.title}" -f description="${m.description}"`, { encoding: 'utf-8' });
      const json = JSON.parse(res);
      milestoneMap[m.title] = json.number;
      console.log(`Created Milestone #${json.number}: ${m.title}`);
    } catch (e) {
      console.log(`Milestone might already exist or error: ${e.message}`);
    }
  }

  // Fetch all milestones to ensure mapping
  try {
    const listRes = execSync(`gh api repos/mevlutseran/twinfit/milestones`, { encoding: 'utf-8' });
    const list = JSON.parse(listRes);
    for (const m of list) {
      milestoneMap[m.title] = m.number;
    }
  } catch (e) {
    console.error("Error fetching milestones list:", e);
  }

  console.log("\nCreating Issues on GitHub...");
  for (const issue of issues) {
    const mNum = milestoneMap[issue.milestone];
    console.log(`Creating issue: ${issue.title} (Milestone #${mNum || 'none'})`);
    try {
      let cmd = `gh issue create --repo mevlutseran/twinfit --title "${issue.title.replace(/"/g, '\\"')}" --body "${issue.body.replace(/"/g, '\\"')}"`;
      if (mNum) {
        cmd += ` --milestone "${issue.milestone}"`;
      }
      const out = execSync(cmd, { encoding: 'utf-8' });
      console.log(`Created issue: ${out.trim()}`);
    } catch (e) {
      console.error(`Error creating issue: ${e.message}`);
    }
  }
  console.log("\nAll Milestones and Issues created successfully on GitHub!");
}

run();
