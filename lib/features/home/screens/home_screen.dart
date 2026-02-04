import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../listing/screens/item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showFilterDialog = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // 1. HEADER SECTION (Logo, Notification, Search)
            _buildHeader(context),

            // 2. CATEGORY CHIPS
            _buildCategoryList(),

            // 3. FEATURED ITEMS SECTION
            _buildSectionHeader(context),

            // 4. GRID OF ITEMS WITH STREAMBUILDER
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('listings').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading listings'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No listings available'));
                  }

                  List<DocumentSnapshot> allDocs = snapshot.data!.docs;
                  List<DocumentSnapshot> filteredDocs = allDocs;

                  // Filter by category
                  if (_selectedCategory != 'All') {
                    filteredDocs = filteredDocs.where((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      return data['category'] == _selectedCategory;
                    }).toList();
                  }

                  // Filter by search query
                  if (_searchQuery.isNotEmpty) {
                    filteredDocs = filteredDocs.where((doc) {
                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                      String title = (data['title'] ?? '').toLowerCase();
                      String description = (data['description'] ?? '').toLowerCase();
                      String category = (data['category'] ?? '').toLowerCase();
                      String query = _searchQuery.toLowerCase();
                      return title.contains(query) || description.contains(query) || category.contains(query);
                    }).toList();
                  }

                  if (filteredDocs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return _buildProductGrid(context, filteredDocs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;

    return Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo placeholder based on your naming
              Flexible(
                child: Image.asset(
                  'logo/i-aswaq_logo_bg.png',
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
              const Icon(Icons.notifications_none, size: 28),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search items, books, electronics...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  _showFilterBottomSheet(context);
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final categories = ['All', 'Electronics', 'Books', 'Clothing', 'Furniture', 'Sports'];
    
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: const Color(0xFFD4A017),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              onSelected: (bool selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Featured Items',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'See All',
              style: TextStyle(color: Color(0xFFD4A017)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<DocumentSnapshot> docs) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;
    final horizontalPadding = screenWidth * 0.04;

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = docs[index].data() as Map<String, dynamic>;
        String listingId = docs[index].id;
        return _buildProductCard(data, listingId);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> data, String listingId) {
    String title = data['title'] ?? 'No Title';
    double price = (data['price'] ?? 0).toDouble();
    String seller = data['seller'] ?? 'Unknown';
    String condition = data['condition'] ?? 'Used';
    List<dynamic> images = data['images'] ?? [];
    String imageUrl = images.isNotEmpty ? images[0] : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(listingId: listingId),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(Icons.image, color: Colors.grey[600]),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'RM ${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFD4A017),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        seller,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: condition == 'New'
                            ? Colors.green[50]
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition,
                        style: TextStyle(
                          fontSize: 10,
                          color: condition == 'New'
                              ? Colors.green[700]
                              : Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),    ),    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final categories = ['All', 'Electronics', 'Books', 'Clothing', 'Furniture', 'Sports'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: const Color(0xFFD4A017),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey[200],
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
