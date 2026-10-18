import 'package:flutter/material.dart';
import 'live_stream_view.dart';
import 'analysis_screen.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback onThemeToggle;
  const DashboardView({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = const Color(0xFF00FFD1);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAŞLIK VE TEMA TUŞU
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A.B.T.",
                      style: TextStyle(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      "Geleceğin Akıllı Bakım Sistemi",
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: onThemeToggle,
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  ),
                  color: accentColor,
                  iconSize: 28,
                ),
              ],
            ),
            const SizedBox(height: 25),

            // ANA DURUM KARTI
            _buildMainCard(context, isDark, accentColor),

            const SizedBox(height: 30),
            Text(
              "Yapay Zeka Analizleri",
              style: TextStyle(
                color: accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildAnalysisGrid(context, isDark, accentColor),

            const SizedBox(height: 30),
            Text(
              "Teknoloji ve Güvenlik",
              style: TextStyle(
                color: accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // ÖNEMLİ SENSÖRLER
            _buildTile(
              "Hareketlilik Takibi",
              "Aktif",
              Icons.shutter_speed,
              accentColor,
              isDark,
            ),
            _buildTile(
              "Solunum (Asfiksi) Kontrolü",
              "Risk Yok",
              Icons.air,
              accentColor,
              isDark,
            ),

            const SizedBox(height: 15),

            // KİŞİSEL ÖĞRENME MODU (Geri eklendi)
            _buildLearningCard(isDark, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, bool isDark, Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1E33) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withOpacity(0.3)),
        boxShadow: [
          if (!isDark) BoxShadow(color: Colors.black12, blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.waves, color: accent, size: 40),
          const SizedBox(height: 15),
          Text(
            "BEBEĞİNİZ ŞU AN RAHAT",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LiveStreamView()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "CANLI GÖRÜNTÜYÜ AÇ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisGrid(BuildContext context, bool isDark, Color accent) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.3,
      children: [
        _analysisBox("Açlık", "%12", Icons.restaurant, Colors.orange, isDark),
        _analysisBox("Uykusuzluk", "%85", Icons.bedtime, accent, isDark),
        _analysisBox("Ağrı/Gaz", "%3", Icons.healing, Colors.redAccent, isDark),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnalysisScreen(),
              ),
            );
          },
          child: _analysisBox(
            "AI Analiz",
            "→",
            Icons.science,
            accent,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _analysisBox(String t, String v, IconData i, Color c, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1D1E33) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(i, color: c),
          Text(
            t,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          Text(
            v,
            style: TextStyle(
              color: c,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String t, String s, IconData i, Color accent, bool isDark) {
    return Card(
      color: isDark ? const Color(0xFF1D1E33) : Colors.white,
      child: ListTile(
        leading: Icon(i, color: accent),
        title: Text(t, style: const TextStyle(fontSize: 14)),
        trailing: Text(
          s,
          style: TextStyle(color: accent, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // KİŞİSEL ÖĞRENME MODU KARTI
  Widget _buildLearningCard(bool isDark, Color accent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent.withOpacity(0.2), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.psychology, color: accent, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kişisel Öğrenme Modu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Bebeğinizin ses karakteri analiz ediliyor...",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.white12,
                  color: accent,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "%65",
            style: TextStyle(color: accent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
