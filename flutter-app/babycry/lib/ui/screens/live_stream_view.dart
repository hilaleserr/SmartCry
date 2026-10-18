import 'package:flutter/material.dart';

class LiveStreamView extends StatelessWidget {
  const LiveStreamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Canlı Gözlem",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Center(
            child: Icon(Icons.videocam_off, color: Colors.white12, size: 80),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1E33).withOpacity(0.8),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF00FFD1).withOpacity(0.3),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _LiveItem(Icons.air, "Nefes", "Normal", Colors.blue),
                  _LiveItem(
                    Icons.visibility,
                    "Göz",
                    "Kapalı",
                    Color(0xFF00FFD1),
                  ),
                  _LiveItem(Icons.warning, "Risk", "Yok", Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveItem extends StatelessWidget {
  final IconData i;
  final String l;
  final String s;
  final Color c;
  const _LiveItem(this.i, this.l, this.s, this.c);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(i, color: c, size: 22),
        Text(l, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        Text(
          s,
          style: TextStyle(color: c, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
