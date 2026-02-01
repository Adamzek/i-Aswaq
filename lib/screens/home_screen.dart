import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Electronics', 'Books', 'Clothing', 'Furniture'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCategoryList(),
              _buildSectionHeader('Featured Items'),
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
              // 1. Clickable Logo
              GestureDetector(
                onTap: () => print("Logo clicked - Refreshing Home"),
                child: Image.asset('logo/i-aswaq_logo_bg.png', height: 30),
              ),
              // 2. Clickable Notification Icon
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 28),
                onPressed: () => print("Opening Notifications"),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // 3. Clickable Filter Button
              InkWell(
                onTap: () => debugPrint("Opening Filters"),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4A017),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            // 4. Clickable Category Chips
            child: ChoiceChip(
              label: Text(cat),
              selected: _selectedCategory == cat,
              selectedColor: const Color(0xFFD4A017),
              onSelected: (bool selected) {
                if (selected) setState(() => _selectedCategory = cat);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // 5. Clickable "See All"
          TextButton(
            onPressed: () => debugPrint("Viewing all featured items"),
            child: const Text('See All', style: TextStyle(color: Color(0xFFD4A017))),
          ),
        ],
      ),
    );
  }

Widget _buildProductGrid() {
    // These items will eventually come from your Firebase collection
    final List<Map<String, String>> items = [
      {'name': 'MacBook Pro 2021 M1', 'price': 'RM 4500.00', 'seller': 'Ahmad Faisal'},
      {'name': 'Calculus Textbook', 'price': 'RM 45.00', 'seller': 'Nurul Izzah'},
      {'name': 'iPhone 13 Pro Max', 'price': 'RM 3200.00', 'seller': 'Muhammad Hafiz'},
      {'name': 'Study Desk Set', 'price': 'RM 280.00', 'seller': 'Siti Aminah'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Disables nested scrolling conflict
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        // 1. Wrap the entire card in an InkWell to make it clickable
        return InkWell(
          onTap: () {
            // This is where you navigate to the detail page
            _navigateToProductDetails(context, item);
          },
          borderRadius: BorderRadius.circular(15),
          child: _buildProductCard(item),
        );
      },
    );
  }

  // 2. Navigation function for the transition
  void _navigateToProductDetails(BuildContext context, Map<String, String> item) {
    if(kDebugMode){
      debugPrint("Navigating to detail page for ${item['name']}");
    }
    // Example navigation code:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: item)));
  }

  Widget _buildProductCard(Map<String, String> item) {
    // 6. Entire Card is Clickable
    return InkWell(
      onTap: () => debugPrint("Navigating to detail page for ${item['name']}"),
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 7. Specifically making the Image area clickable
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
                  ),
                  // Optional: Clickable "Like" or "Favorite" icon on the picture
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => print("Added to favorites"),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 14,
                        child: Icon(Icons.favorite_border, size: 16, color: Colors.red),
                      ),
                    ),
                  ),
                ],
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
                  // 8. Clickable Seller Profile
                  GestureDetector(
                    onTap: () => print("Opening ${item['seller']}'s profile"),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 8, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 10, color: Colors.white)),
                        const SizedBox(width: 4),
                        Text(item['seller']!, style: const TextStyle(fontSize: 10, color: Colors.blueAccent, decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
