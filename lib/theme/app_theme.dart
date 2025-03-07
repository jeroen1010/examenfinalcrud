import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2A2438);
  static const Color secondaryColor = Color(0xFF352F44);
  static const Color accentColor = Color(0xFF5C5470);
  static const Color backgroundLight = Color(0xFFDBD8E3);
  static const Color backgroundDark = Color(0xFF1D1C1C); 
  static const Color accentDark = Color(0xFF2A2A2A); 

  // Tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: backgroundLight),
        titleTextStyle: TextStyle(
          color: backgroundLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: backgroundLight,
        unselectedItemColor: backgroundLight.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: secondaryColor,
        ),
      ),
      cardTheme: CardTheme(
        color: accentColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: backgroundDark),
        titleTextStyle: TextStyle(
          color: backgroundDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: backgroundDark,
        unselectedItemColor: backgroundDark.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: accentDark,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: accentDark,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: accentDark,
        ),
      ),
      cardTheme: CardTheme(
        color: accentDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static BoxDecoration get sectionDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ), 
        ],
      );

  static BoxDecoration get dayBoxDecoration => BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ), 
        ],
      );
}
