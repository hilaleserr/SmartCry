import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/dashboard_view.dart';
import 'ui/screens/analysis_screen.dart';

void main() => runApp(const BebekTelsiziApp());

class BebekTelsiziApp extends StatefulWidget {
  const BebekTelsiziApp({super.key});

  @override
  State<BebekTelsiziApp> createState() => _BebekTelsiziAppState();
}

class _BebekTelsiziAppState extends State<BebekTelsiziApp> {
  ThemeMode _themeMode = ThemeMode.dark; // Varsayılan Flyer (Koyu) Teması

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Akıllı Bebek Telsizi',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: DashboardView(onThemeToggle: _toggleTheme),
    );
  }
}
