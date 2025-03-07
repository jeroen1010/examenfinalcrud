import 'package:flutter/material.dart';

BottomNavigationBar tapBar({
  required int currentIndex,
  required Function(int) onTap, 
  required Color primaryColor,
  required Color backgroundLight,
  required Color textColor,
}) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    onTap: onTap, 
    backgroundColor: primaryColor,
    selectedItemColor: backgroundLight,
    unselectedItemColor: textColor.withOpacity(0.7),
    showSelectedLabels: true,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.fastfood),
        label: 'Dietas',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.show_chart),
        label: 'Progreso',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.thumb_up),
        label: 'Recomendaciones',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
    ],
  );
}

