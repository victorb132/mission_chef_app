import 'package:flutter/material.dart';
import 'package:master_chef_app/pages/challenges_page.dart';
import 'package:master_chef_app/pages/favorites_page.dart';
import 'package:master_chef_app/pages/home_page.dart';
import 'package:master_chef_app/pages/search_page.dart';
import 'package:master_chef_app/utils/app_colors.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SearchPage(),
    const FavoritesPage(),
    const ChallengesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Remove o efeito de splash
          highlightColor: Colors.transparent, // Remove o efeito de destaque
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.terciaryText,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: _buildIconWithIndicator(Icons.home, 0),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: _buildIconWithIndicator(Icons.search, 1),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: _buildIconWithIndicator(Icons.favorite_outline, 2),
              label: "Favoritos",
            ),
            BottomNavigationBarItem(
              icon: _buildIconWithIndicator(Icons.food_bank_outlined, 3),
              label: "Favoritos",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithIndicator(IconData icon, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28),
        const SizedBox(height: 4),
        if (_selectedIndex == index)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
