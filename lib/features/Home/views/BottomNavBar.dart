import 'package:flutter/material.dart';
import 'package:saloony/core/constants/app_routes.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // Liste des routes correspondantes à chaque icône
  final List<String> _routes = [
    AppRoutes.home,      // index 0 → Home
    '',                  // index 1 → calendrier (non défini)
    '',                  // index 2 → favoris (non défini)
    AppRoutes.profile,   // index 3 → Profil
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    final routeName = _routes[index];

    if (routeName.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeName,
        (route) => false, // pour réinitialiser la pile
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 0),
              _buildNavItem(Icons.calendar_today_rounded, 1),
              _buildNavItem(Icons.favorite_border_rounded, 2),
              _buildNavItem(Icons.person_outline_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1B2B3E)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? const Color(0xFFF0CD97)
              : Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }
}
