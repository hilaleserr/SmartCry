/// SmartCry Analiz Modeli
/// Bebek ağlaması analiz sonuçlarını içerir

class CryAnalysis {
  final String cryReason; // Açlık, Uykusuzluk, Rahatsızlık
  final double confidence; // Doğruluk oranı (0.0 - 1.0)
  final String mobility; // Hareketlilik Skoru
  final DateTime time;
  final Map<String, dynamic>? features; // AI özellikleri (Mel-Spektrogram, MFCC)

  CryAnalysis({
    required this.cryReason,
    required this.confidence,
    required this.mobility,
    required this.time,
    this.features,
  });

  /// JSON'dan model oluştur
  factory CryAnalysis.fromJson(Map<String, dynamic> json) {
    return CryAnalysis(
      cryReason: json['cry_reason'] ?? 'Bilinmiyor',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      mobility: json['mobility'] ?? 'N/A',
      time: json['time'] != null
          ? DateTime.parse(json['time'])
          : DateTime.now(),
      features: json['features'],
    );
  }

  /// Modeli JSON'a çevir
  Map<String, dynamic> toJson() {
    return {
      'cry_reason': cryReason,
      'confidence': confidence,
      'mobility': mobility,
      'time': time.toIso8601String(),
      'features': features,
    };
  }

  /// Güven yüzdesini döndür
  int get confidencePercent => (confidence * 100).toInt();

  /// İnsan okunabilir açıklama
  String get description {
    final reasonMap = {
      'hungry': '🍽️ Açlık',
      'burping': '🤢 Gaz çıkarma',
      'discomfort': '😖 Rahatsızlık',
      'belly_pain': '🤕 Karın ağrısı',
      'tired': '😴 Yorgunluk',
    };
    return reasonMap[cryReason] ?? cryReason;
  }
}

/// Kategori Bilgisi
class CryCategory {
  final String id;
  final String name;
  final String emoji;
  final String description;

  CryCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
  });

  factory CryCategory.fromJson(String id, dynamic value) {
    final parts = value.toString().split(' ');
    final emoji = parts.first;
    final name = parts.skip(1).join(' ');

    return CryCategory(
      id: id,
      name: name,
      emoji: emoji,
      description: value.toString(),
    );
  }
}
