import 'package:flutter/material.dart';

class AppTheme {
  // 1. DEFINICJA ZESTAWÓW KOLORÓW (PALETY)
  static const String _fontFamily = 'PixelifySans';

  // Zestaw 1: Klasyczny Blue
  static const Color _bluePrimary = Colors.blue;
  static const Color _blueAccent = Colors.blueAccent;

  // Zestaw 2: Green
  static const Color _greenPrimary = Colors.green;
  static const Color _greenAccent = Colors.lightGreen;

  // Zestaw 3: Purple
  static const Color _purplePrimary = Colors.deepPurple;
  static const Color _purpleAccent = Colors.amber;

  // Zestaw 4: Cinnamonroll
  static const Color _cinnamonrollPrimary = Color(0xFF81D5FC);
  static const Color _cinnamonrollAccent = Color(0xFFFFCCF4);

  static const Color baseTextColor = Colors.black87;

  // ============================================================
  // TU JEST KLUCZOWA ZMIANA (Używamy 'get' i '=>')
  // ============================================================
  
  // Zamiast 'static final ... =', używamy 'static ThemeData get ... =>'
  // Dzięki temu Hot Reload wymusi przeliczenie tego kodu na nowo.
  
  static ThemeData get lightTheme => _buildTheme(_bluePrimary, _blueAccent);

  static ThemeData get greenTheme => _buildTheme(_greenPrimary, _greenAccent);
  
  static ThemeData get purpleTheme => _buildTheme(_purplePrimary, _purpleAccent);
  
  static ThemeData get cinnamonrollTheme => _buildTheme(_cinnamonrollPrimary, _cinnamonrollAccent);


  // 3. Builder motywu
  static ThemeData _buildTheme(Color primaryColor, Color accentColor) {
    return ThemeData(
      fontFamily: _fontFamily,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        brightness: Brightness.light,
        onSurface: baseTextColor,
      ),

      textTheme: TextTheme(
        // DLA NAGŁÓWKÓW (Duże napisy)
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: baseTextColor,
        ),

        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: baseTextColor,
        ),

        // DLA ZWYKŁEGO TEKSTU
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: baseTextColor,
        ),

        // Opcjonalnie mały tekst
        bodySmall: TextStyle(color: Colors.grey.shade600),
      ),

      listTileTheme: ListTileThemeData(
        // Kolor ikony po lewej (leading)
        iconColor: primaryColor,

        // Kolor (tytułu)
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 19, 
          fontWeight: FontWeight.w600,
          color: baseTextColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        // STANY AKTYWNE
        selectedColor: primaryColor,
        selectedTileColor: accentColor.withOpacity(0.3),
      ),

      // 1. Stylizacja AppBara
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // 2. Stylizacja Inputów
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: borderSide(Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIconColor: Colors.grey,
      ),

      // 3. Stylizacja Przycisków
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Helper do ramek
  static BorderSide borderSide(Color color) => BorderSide(color: color);
}