import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/listing/screens/add_listing_screen.dart';
import '../features/chat/screens/chat_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/categories/screens/categories_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Screens for each screens in nav
  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // The center "+" button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
          setState(() {});
        }, 
        backgroundColor: const Color(0xFFD4A017),
        elevation: 4.0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // The bottom bar 
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
              _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 'Categories', 1),
              const SizedBox(width: 40), // Space for the floating button
              _buildNavItem(Icons.chat_bubble_outline, Icons.chat_bubble, 'Chat', 2),
              _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    
    // active vs inactive colours
    final Color activeColor = const Color(0xFFD4A017); // active Yellow
    final Color inactiveColor = Colors.black;          // Default Black

    return GestureDetector(
      behavior: HitTestBehavior.opaque, // Ensures the whole area is clickable
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? activeColor : inactiveColor, // icon colour
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? activeColor : inactiveColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
