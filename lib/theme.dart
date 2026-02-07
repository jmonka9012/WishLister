import 'package:flutter/material.dart';

class AppTheme {
  // 1. DEFINICJA ZESTAWÓW KOLORÓW (PALETY)
  
  // Zestaw 1: Klasyczny Blue 
  static const Color _bluePrimary = Colors.blue;
  static const Color _blueAccent = Colors.blueAccent;

  // Zestaw 2: Green
  static const Color _greenPrimary = Colors.green;
  static const Color _greenAccent = Colors.lightGreen;

  // Zestaw 3: Purple
  static const Color _purplePrimary = Colors.deepPurple;
  static const Color _purpleAccent = Colors.amber; 
  
  // To przypisujemy w main.dart (obecnie używamy niebieskiego)
  static final ThemeData lightTheme = _buildTheme(_bluePrimary, _blueAccent);

  // Te będą dostępne na przyszłość do przełączania:
  static final ThemeData greenTheme = _buildTheme(_greenPrimary, _greenAccent);
  static final ThemeData purpleTheme = _buildTheme(_purplePrimary, _purpleAccent);


  // 3. Builde rmotywu

  static ThemeData _buildTheme(Color primaryColor, Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        brightness: Brightness.light,
      ),


      // 1. Stylizacja AppBara
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
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
          // Tutaj dynamicznie podstawiamy kolor główny zestawu
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIconColor: Colors.grey,
      ),

      // 3. Stylizacja Przycisków
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Dynamiczny kolor tła
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper do ramek
  static BorderSide borderSide(Color color) => BorderSide(color: color);
}