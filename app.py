from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.utils import secure_filename
import os
import sys
import numpy as np

app = Flask(__name__)
CORS(app) # Flutter bağlantısı için kritik

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, "uploads")
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# AI Modülleri (Yolun doğru olduğundan emin olun)
sys.path.insert(0, os.path.join(BASE_DIR, "AI"))
try:
    from feature_extractor import extract_mfcc_cnn
    from mel_extractor import extract_mel_cnn
except ImportError as e:
    print(f"Modül yükleme hatası: {e}")

# --- Rotalar (Routes) ---

@app.route("/", methods=["GET"])
def root():
    return jsonify({"status": "ok", "message": "SmartCry API Çalışıyor"}), 200

@app.route("/api/health", methods=["GET"])
def health_check():
    return jsonify({"status": "healthy", "service": "SmartCry"}), 200

@app.route("/api/categories", methods=["GET"])
def get_categories():
    # Flutter uygulamasındaki Map yapısına uygun format
    return jsonify({
        "status": "ok",
        "categories": {
            "0": "🍼 Açlık",
            "1": "😴 Uykusuzluk",
            "2": "💨 Gaz Sancısı",
            "3": "🎈 Alt Islak",
            "4": "🌡️ Rahatsızlık"
        }
    }), 200

@app.route("/api/analyze/mel", methods=["POST"])
def analyze_mel():
    if "audio" not in request.files:
        return jsonify({"error": "Ses dosyası yok"}), 400
    
    file = request.files["audio"]
    filepath = os.path.join(UPLOAD_FOLDER, secure_filename(file.filename))
    
    try:
        file.save(filepath)
        features = extract_mel_cnn(filepath) # AI işlemi
        return jsonify({
            "success": True,
            "type": "MEL",
            "features": {"mean": float(np.mean(features))}
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if os.path.exists(filepath): os.remove(filepath)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)