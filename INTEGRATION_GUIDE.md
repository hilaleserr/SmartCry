# SmartCry - Entegrasyon Rehberi

## 📋 Proje Yapısı

```
SmartCry-telsiz-main/
├── app.py                           # Flask Backend API
├── requirements.txt                 # Python bağımlılıkları
├── AI/
│   ├── feature_extractor.py        # MFCC çıkarıcı
│   ├── mel_extractor.py             # Mel-Spektrogram çıkarıcı
│   └── data/                        # Eğitim verileri
├── flutter-app/babycry/
│   ├── lib/
│   │   ├── main.dart               # Ana uygulama
│   │   └── data/
│   │       └── services/
│   │           └── cry_analysis_service.dart  # API İstemcisi
│   └── pubspec.yaml                # Flutter bağımlılıkları
└── uploads/                         # Geçici ses dosyaları
```

## 🚀 Kurulum ve Çalıştırma

### 1. Backend (Python)

#### Gereksinimler
- Python 3.8+
- pip

#### Kurulum

```bash
# Proje dizinine git
cd SmartCry-telsiz-main

# Virtual environment oluştur (opsiyonel ama önerilen)
python -m venv venv

# Virtual environment'ı etkinleştir
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

# Bağımlılıkları yükle
pip install -r requirements.txt
```

#### API Sunucusunu Başlat

```bash
python app.py
```

**Beklenen Çıktı:**
```
**************************************************
*                                              *
*  SmartCry Backend API - Başlatılıyor...     *
*                                              *
**************************************************
[INFO] Flask Server: http://localhost:5000
[INFO] CORS: Etkinleştirildi (Flutter entegrasyonu)
[INFO] Modüller: Feature Extractor, Mel Extractor
```

### 2. Flutter Uygulaması

#### Gereksinimler
- Flutter SDK 3.10+
- Android SDK / Xcode (geliştirme için)

#### Kurulum

```bash
# Flutter dependencies'i yükle
cd flutter-app/babycry
flutter pub get
```

#### Android Emülatör Ayarı

**Çalıştırırken Backend'e bağlanmak için:**

- **Emülatör kullanıyorsanız:** `baseUrl = 'http://10.0.2.2:5000/api'`
- **Fiziksel cihaz/Wi-Fi:** `baseUrl = 'http://192.168.1.100:5000/api'` (IP adresi değişir)

[cry_analysis_service.dart](flutter-app/babycry/lib/data/services/cry_analysis_service.dart) dosyasında değiştir.

#### Uygulamayı Çalıştır

```bash
# Debug modda
flutter run

# Release modda
flutter run --release
```

## 🔌 API Endpoints

### 1. Sağlık Kontrolü
```
GET /api/health
Response: 200 OK
{
  "status": "healthy",
  "message": "SmartCry Backend aktif",
  "version": "1.0.0"
}
```

### 2. Mel-Spektrogram Analizi
```
POST /api/analyze/mel
Body: form-data
  - audio: [ses_dosyası.wav]

Response: 200 OK
{
  "success": true,
  "features": {
    "shape": [128, 94, 1],
    "dtype": "float32",
    "min": -2.5,
    "max": 2.5,
    "mean": 0.0,
    "std": 1.0
  },
  "filename": "ses_dosyası.wav",
  "message": "Mel-Spektrogram başarıyla çıkarıldı"
}
```

### 3. MFCC Analizi
```
POST /api/analyze/mfcc
Body: form-data
  - audio: [ses_dosyası.wav]

Response: 200 OK
{
  "success": true,
  "features": {
    "shape": [120, 94, 1],
    "dtype": "float32",
    ...
  },
  "filename": "ses_dosyası.wav",
  "message": "MFCC başarıyla çıkarıldı"
}
```

### 4. Kategorileri Al
```
GET /api/categories
Response: 200 OK
{
  "categories": {
    "hungry": "🍽️ Açlık",
    "burping": "🤢 Gaz çıkarma",
    "discomfort": "😖 Rahatsızlık",
    "belly_pain": "🤕 Karın ağrısı",
    "tired": "😴 Yorgunluk"
  },
  "total": 5
}
```

### 5. API Bilgileri
```
GET /api/info
Response: 200 OK
{
  "name": "SmartCry AI Backend",
  "version": "1.0.0",
  "endpoints": { ... },
  "supported_formats": ["wav", "mp3", "ogg", "m4a"],
  "max_file_size": "10 MB"
}
```

## 📱 Flutter'da Kullanım Örneği

```dart
import 'package:babycry/data/services/cry_analysis_service.dart';

// Sağlık kontrolü
final isHealthy = await CryAnalysisService.healthCheck();
if (isHealthy) {
  print('✅ Backend bağlı!');
}

// Mel-Spektrogram analizi
try {
  final result = await CryAnalysisService.analyzeMel('/path/to/audio.wav');
  print('Sonuç: ${result['features']['shape']}');
} catch (e) {
  print('Hata: $e');
}

// MFCC analizi
try {
  final result = await CryAnalysisService.analyzeMfcc('/path/to/audio.wav');
  print('MFCC Shape: ${result['features']['shape']}');
} catch (e) {
  print('Hata: $e');
}

// Kategorileri al
final categories = await CryAnalysisService.getCategories();
print('Kategoriler: ${categories['categories']}');
```

## 🧪 API Test Etme (cURL)

```bash
# Sağlık kontrolü
curl http://localhost:5000/api/health

# Mel analizi (Windows PowerShell)
$file = Get-ChildItem 'C:\path\to\audio.wav'
$form = @{
    'audio' = $file
}
Invoke-WebRequest -Uri "http://localhost:5000/api/analyze/mel" -Method Post -Form $form

# Kategorileri al
curl http://localhost:5000/api/categories

# API bilgileri
curl http://localhost:5000/api/info
```

## 🐛 Sorun Giderme

### 1. "Connection refused" Hatası
- Backend sunucusunun çalışıp çalışmadığını kontrol et
- `python app.py` komutunu çalıştır
- Port 5000'in dolu olmadığını kontrol et

### 2. CORS Hatası
- Flask-CORS kurulu mu? `pip install Flask-CORS`
- Backend otomatik olarak CORS destekler

### 3. "ModuleNotFoundError: No module named 'librosa'"
- Virtual environment'ı etkinleştir
- `pip install -r requirements.txt` çalıştır

### 4. Emülatörde bağlanamama
- `cry_analysis_service.dart`'da `baseUrl`'i kontrol et
- Emülatör: `http://10.0.2.2:5000/api`
- Fiziksel cihaz: `http://[IP_ADRESI]:5000/api`

### 5. Dosya hataları
- Ses dosyası destek formatlardan birinde olmalı: wav, mp3, ogg, m4a
- Dosya boyutu 10 MB'dan az olmalı
- Dosya yolu doğru olmalı

## 📊 Özellik Çıkarma Parametreleri

### Mel-Spektrogram Ayarları
```python
n_mels=128       # Mel bandı sayısı
n_fft=2048       # FFT window boyutu
hop_length=512   # Frame arasındaki örnek sayısı
fmax=8000        # Maksimum frekans (Hz)
sr=16000         # Örnekleme hızı
duration=3.0     # Ses süresi (saniye)
```

### MFCC Ayarları
```python
n_mfcc=40        # MFCC katsayı sayısı
n_fft=2048       # FFT window boyutu
hop_length=512   # Frame arasındaki örnek sayısı
pre_emphasis=0.97 # Pre-emphasis filtresi
sr=16000         # Örnekleme hızı
duration=3.0     # Ses süresi (saniye)
```

## 🔐 Güvenlik Notları

- API açık internette çalışırsa kimlik doğrulama ekle
- Dosya boyutu limitini kontrol et (`MAX_FILE_SIZE`)
- İnput validasyonu yapıl
- HTTPS kullan (production'da)

## 📝 Sonraki Adımlar

1. ✅ ML Modeli Eğit (CNN)
2. ✅ Kategorilendirme sonuçlarını dön
3. ✅ Veritabanı entegrasyonu
4. ✅ Kullanıcı arayüzü geliştirme
5. ✅ Mobile cihazlarda mikrofon entegrasyonu

---
**SmartCry © 2024** - Akıllı Bebek Telsizi
