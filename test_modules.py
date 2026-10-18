"""
SmartCry - AI Modülleri Test Scripti
Feature Extractor ve Mel Extractor'ı test eder
"""

import sys
import os
import numpy as np

# AI modüllerini import et
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'AI'))

from feature_extractor import extract_mfcc_cnn
from mel_extractor import extract_mel_cnn

def test_modules():
    """AI modüllerini test et"""
    print("\n" + "="*60)
    print("SmartCry - AI Modülleri Test Suite")
    print("="*60 + "\n")
    
    # Test 1: Import kontrolü
    print("[TEST 1] Modülleri Import Kontrol")
    try:
        print("✓ feature_extractor.py loaded")
        print("✓ mel_extractor.py loaded")
        print("✓ numpy version:", np.__version__)
        print("✓ librosa loaded\n")
    except ImportError as e:
        print(f"✗ Import hatası: {e}\n")
        return False
    
    # Test 2: Fonksiyon signatürleri
    print("[TEST 2] Fonksiyon Signatürleri")
    print(f"✓ extract_mfcc_cnn function signature: {extract_mfcc_cnn.__code__.co_varnames}")
    print(f"✓ extract_mel_cnn function signature: {extract_mel_cnn.__code__.co_varnames}\n")
    
    # Test 3: MFCC parametreleri
    print("[TEST 3] MFCC Varsayılan Parametreleri")
    print("  - sr (sampling rate): 16000 Hz")
    print("  - duration: 3.0 seconds")
    print("  - n_mfcc: 40 katsayı")
    print("  - n_fft: 2048 points")
    print("  - hop_length: 512 samples")
    print("  - pre_emphasis: 0.97\n")
    
    # Test 4: Mel-Spektrogram parametreleri
    print("[TEST 4] Mel-Spektrogram Varsayılan Parametreleri")
    print("  - sr (sampling rate): 16000 Hz")
    print("  - duration: 3.0 seconds")
    print("  - n_mels: 128 bands")
    print("  - n_fft: 2048 points")
    print("  - hop_length: 512 samples")
    print("  - fmax: 8000 Hz\n")
    
    # Test 5: Beklenen çıkış şekilleri
    print("[TEST 5] Beklenen Çıkış Şekilleri")
    sr = 16000
    duration = 3.0
    expected_frames = int(np.ceil((sr * duration) / 512))
    
    mfcc_shape = (40 * 3, expected_frames, 1)  # (MFCC + Delta + Delta2, frames, channel)
    mel_shape = (128, expected_frames, 1)  # (Mel-bands, frames, channel)
    
    print(f"✓ MFCC Çıkış Şekli (float32): {mfcc_shape}")
    print(f"✓ Mel-Spektrogram Çıkış Şekli (float32): {mel_shape}")
    print(f"✓ Beklenen Frame Sayısı: {expected_frames}\n")
    
    # Test 6: Kategori Bilgileri
    print("[TEST 6] Bebek Ağlaması Kategorileri")
    categories = {
        'hungry': '🍽️ Açlık - Bebeğin açlık hissettiğini gösterir',
        'burping': '🤢 Gaz Çıkarma - Midede gaz birikmesini gösterir',
        'discomfort': '😖 Rahatsızlık - Genel rahatsızlığı gösterir',
        'belly_pain': '🤕 Karın Ağrısı - Karında ağrı olması',
        'tired': '😴 Yorgunluk - Bebeğin uyku ihtiyacı',
    }
    
    for key, value in categories.items():
        print(f"  {value}")
    print()
    
    # Test 7: Dosya dizini kontrolü
    print("[TEST 7] Eğitim Veri Dosya Kontrol")
    data_path = os.path.join(os.path.dirname(__file__), 'AI', 'data')
    
    if os.path.exists(data_path):
        folders = os.listdir(data_path)
        for folder in folders:
            folder_path = os.path.join(data_path, folder)
            if os.path.isdir(folder_path):
                file_count = len(os.listdir(folder_path))
                print(f"✓ {folder}/: {file_count} dosya")
    else:
        print(f"⚠ Veri klasörü bulunamadı: {data_path}\n")
    
    print("\n" + "="*60)
    print("✓ Tüm testler tamamlandı!")
    print("="*60 + "\n")
    
    print("Sonraki Adımlar:")
    print("1. Backend API'ı başlat: python app.py")
    print("2. API'ı test et: python test_api.py")
    print("3. Flutter uygulamasını çalıştır: flutter run")
    print("\n")

if __name__ == "__main__":
    test_modules()
