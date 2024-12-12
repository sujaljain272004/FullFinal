import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'welcome_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
class NavigationMainPage extends StatefulWidget {
  const NavigationMainPage({super.key});

  @override
  State<NavigationMainPage> createState() => _NavigationMainPageState();
}

class _NavigationMainPageState extends State<NavigationMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const WelcomePage(username: ''),
    const SearchPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 56,
          margin: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _buildNavItem(
                icon: Icons.explore_rounded,
                label: 'Explore',
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _buildNavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4B5EFC) : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFF4B5EFC).withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 18,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4B5EFC) : Colors.grey,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

