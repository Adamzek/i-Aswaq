import 'package:flutter/material.dart';
import '../../../core/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = getDummyCategories();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = (constraints.maxWidth - 16) / crossAxisCount;
                    final itemHeight = itemWidth * 1.15;
                    
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: itemWidth / itemHeight,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryCard(
                          category: categories[index],
                          isOthers: categories[index].name == 'Others',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required Category category,
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
      child: InkWell(
        onTap: () {
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF9E6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: mustardYellow,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${category.itemCount} items',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
