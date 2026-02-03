import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Browse items by category',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _buildCategoryCard(
                      icon: Icons.checkroom_outlined,
                      categoryName: 'Clothing',
                      itemCount: 156,
                      isOthers: false,
                    ),
                    _buildCategoryCard(
                      icon: Icons.weekend_outlined,
                      categoryName: 'Furniture',
                      itemCount: 43,
                      isOthers: false,
                    ),
                    _buildCategoryCard(
                      icon: Icons.sports_basketball_outlined,
                      categoryName: 'Sports',
                      itemCount: 67,
                      isOthers: false,
                    ),
                    _buildCategoryCard(
                      icon: Icons.edit_outlined,
                      categoryName: 'Stationery',
                      itemCount: 32,
                      isOthers: false,
                    ),
                    _buildCategoryCard(
                      icon: Icons.more_horiz,
                      categoryName: 'Others',
                      itemCount: 78,
                      isOthers: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String categoryName,
    required int itemCount,
    required bool isOthers,
  }) {
    const mustardYellow = Color(0xFFEAC847);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isOthers
            ? const BorderSide(color: mustardYellow, width: 2)
            : BorderSide.none,
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: mustardYellow,
                size: 35,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              categoryName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$itemCount items',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
