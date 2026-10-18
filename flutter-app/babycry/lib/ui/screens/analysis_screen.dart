import 'package:flutter/material.dart';
import '../../data/services/cry_analysis_service.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool _isConnected = false;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _categories;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Uygulama başladığında verileri çeker
  Future<void> _initializeData() async {
    await _checkConnection();
    // Sadece bağlantı gerçek anlamda varsa kategorileri yükle
    if (_isConnected) {
      await _loadCategories();
    }
  }

  /// Backend durumunu kontrol eder
  Future<void> _checkConnection() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Servisten gelen bool değeri kontrol et
      final bool connected = await CryAnalysisService.healthCheck();

      if (!mounted) return;

      setState(() {
        _isConnected = connected;
        _isLoading = false;
        if (!connected) {
          // IP doğru ama Backend mantıksal hata döndürüyor (success: false gibi)
          _errorMessage =
              'Backend Erişilebilir Fakat Hata Döndürüyor.\n'
              'İpucu: Python terminalindeki hataları kontrol edin (Model yüklü mü?)';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _errorMessage =
            'Bağlantı Kurulamadı!\n'
            'Detay: IP adresi yanlış veya sunucu kapalı olabilir.\n($e)';
      });
    }
  }

  /// API'den bebek ağlama kategorilerini çeker
  Future<void> _loadCategories() async {
    try {
      final categories = await CryAnalysisService.getCategories();
      if (!mounted) return;
      setState(() => _categories = categories);
    } catch (e) {
      debugPrint('Kategori yükleme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCry: Analiz Paneli'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeData,
          ),
        ],
      ),
      body: _isLoading && _categories == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _initializeData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatusCard(),
                    const SizedBox(height: 24),
                    if (_categories != null) _buildCategoryHeader(),
                    if (_categories != null) _buildCategoryGrid(),
                    const SizedBox(height: 30),
                    if (_isConnected) _buildAnalyzeButtons(),
                  ],
                ),
              ),
            ),
    );
  }

  // --- UI BİLEŞENLERİ ---

  Widget _buildStatusCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _isConnected ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      color: _isConnected
          ? Colors.green.withOpacity(0.05)
          : Colors.red.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.dangerous,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  _isConnected
                      ? 'Sunucu Bağlantısı Aktif'
                      : 'Sunucu Bağlantısı Yok',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isConnected
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ],
            ),
            if (_errorMessage != null) ...[
              const Divider(height: 20),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        'Tespit Edilebilir Kategoriler',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final entries = (_categories!['categories'] as Map).entries.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final categoryString = entries[index].value.toString();
        final parts = categoryString.split(' ');
        final emoji = parts[0];
        final label = parts.skip(1).join(' ');

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 30)),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyzeButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {}, // Servis çağrısı eklenebilir
          icon: const Icon(Icons.mic),
          label: const Text('Şimdi Dinle ve Analiz Et'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
