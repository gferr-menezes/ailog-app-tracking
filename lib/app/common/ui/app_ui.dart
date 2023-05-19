import 'package:flutter/material.dart';

class AppUI {
  AppUI._();

  static final ThemeData theme = ThemeData(
    primaryColor: const Color(0xFF007D21),
    primaryColorDark: const Color(0xFF00343F),
    primaryColorLight: const Color.fromARGB(255, 187, 209, 186),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007D21),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: Colors.black,
      selectedIconTheme: const IconThemeData(color: Colors.black),
      selectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedItemColor: Colors.grey[400],
      unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
    ),
  );

  static const TextStyle textBold = TextStyle(
    fontWeight: FontWeight.bold,
  );
}
