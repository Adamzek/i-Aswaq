import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER SECTION (Logo, Notification, Search)
              _buildHeader(),

              // 2. CATEGORY CHIPS
              _buildCategoryList(),

              // 3. FEATURED ITEMS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Items',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All', style: TextStyle(color: Color(0xFFD4A017))),
                    ),
                  ],
                ),
              ),

              // 4. GRID OF ITEMS
              _buildProductGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo placeholder based on your naming
              Image.asset('logo/i-aswaq_logo_bg.png', height: 30),
              const Icon(Icons.notifications_none, size: 28),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search items, books, electronics...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.tune), // Filter icon
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = ['All', 'Electronics', 'Books', 'Clothing', 'Furniture'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = index == 0; // "All" is selected by default
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(categories[index]),
              selected: isSelected,
              selectedColor: const Color(0xFFD4A017),
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              backgroundColor: Colors.white,
              onSelected: (bool selected) {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    // Sample data matching your mockup
    final List<Map<String, String>> items = [
      {'name': 'MacBook Pro 2021 M1', 'price': 'RM 4500.00', 'seller': 'Ahmad Faisal', 'tag': 'Used'},
      {'name': 'Calculus Textbook', 'price': 'RM 45.00', 'seller': 'Nurul Izzah', 'tag': 'New'},
      {'name': 'iPhone 13 Pro Max', 'price': 'RM 3200.00', 'seller': 'Muhammad Hafiz', 'tag': 'Used'},
      {'name': 'Study Desk Set', 'price': 'RM 280.00', 'seller': 'Siti Aminah', 'tag': 'Used'},
    ];

    return GridView.builder(
      shrinkWrap: true, // Allows GridView to work inside SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildProductCard(items[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, String> item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(child: Icon(Icons.image, color: Colors.grey[600])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1),
                const SizedBox(height: 4),
                Text(item['price']!, style: const TextStyle(color: Color(0xFFD4A017), fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const CircleAvatar(radius: 8, backgroundColor: Colors.grey),
                    const SizedBox(width: 4),
                    Text(item['seller']!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
    ),
    );
  }
  }
