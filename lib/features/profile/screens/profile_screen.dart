import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_screen.dart';
import '../../listing/screens/item_details_screen.dart';
import '../../../core/services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = FirestoreService();
  String _userName = 'User';
  String _userEmail = '';
  String? _userInitial;
  String? _profileImageUrl;
  int _myListingsCount = 0;
  int _savedItemsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCounts();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';

        // Use displayName if available, otherwise generate a username
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          _userName = user.displayName!;
        } else {
          // Generate username from email or UID
          if (user.email != null) {
            _userName =
                'User${user.email!.split('@')[0].substring(0, 3).toUpperCase()}';
          } else {
            _userName = 'User${user.uid.substring(0, 6).toUpperCase()}';
          }
        }

        // Get first letter of username for avatar
        _userInitial = _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U';
      });

      // Load profile picture from Firestore
      final userData = await _firestoreService.getUser(user.uid);
      if (userData != null) {
        setState(() {
          _profileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  void _loadCounts() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Get my listings count
    final listingsSnapshot = await _firestore
        .collection('listings')
        .where('userId', isEqualTo: user.uid)
        .get();

    // Get saved items count
    final savedSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedItems')
        .get();

    setState(() {
      _myListingsCount = listingsSnapshot.docs.length;
      _savedItemsCount = savedSnapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;

    User? currentUser = FirebaseAuth.instance.currentUser;
    String userName = currentUser?.email?.split('@').first ?? 'User';
    String userEmail = currentUser?.email ?? 'No email';
    String userInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                      // Reload user data when returning from settings
                      _loadUserData();
                      _loadCounts();
                    },
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 2. The User Info Card (Cream colored box)
              _buildUserInfoCard(screenWidth, context),
              const SizedBox(height: 25),

              // 3. Stats Row (The 3 small cards)
              _buildStatsRow(screenWidth),
              const SizedBox(height: 30),

              // 4. Menu Items
              _buildSection(
                title: 'My Activity',
                children: [
                  _buildMenuTile(
                    Icons.inventory_2_outlined,
                    'My Listings',
                    _myListingsCount.toString(),
                    () {
                      _showMyListings();
                    },
                  ),
                  _buildMenuTile(
                    Icons.favorite_border,
                    'Saved Items',
                    _savedItemsCount.toString(),
                    () {
                      _showSavedItems();
                    },
                  ),
                  _buildMenuTile(Icons.history, 'Purchase History', '', () {}),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(double screenWidth, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // The Avatar with user initial
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFF2D06B).withValues(alpha: 0.3),
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _profileImageUrl == null
                    ? Text(
                        _userInitial ?? 'U',
                        style: const TextStyle(
                          fontSize: 30,
                          color: Color(0xFFD4A017),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 15),
              // Name and Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _userEmail,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
                // Reload user data when returning from settings
                _loadUserData();
                _loadCounts();
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 18,
                color: Color(0xFFD4A017),
              ),
              label: const Text(
                'Edit Profile',
                style: TextStyle(color: Color(0xFFD4A017)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD4A017)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(double screenWidth) {
    final isSmallScreen = screenWidth < 350;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildStatCard(
            _myListingsCount.toString(),
            'Active\nListings',
            isSmallScreen,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: _buildStatCard(
            _savedItemsCount.toString(),
            'Saved\nItems',
            isSmallScreen,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(child: _buildStatCard('2024', 'Member\nSince', isSmallScreen)),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 15 : 20,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFD4A017),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 11,
              color: Colors.grey,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    IconData icon,
    String title,
    String trailing,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withValues(alpha: 0.2),
        highlightColor: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFD4A017)),
          ),
          title: Text(title),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing.isNotEmpty)
                Text(trailing, style: const TextStyle(color: Colors.grey)),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _showMyListings() {
    final user = _auth.currentUser;
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('My Listings'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('listings')
                .where('userId', isEqualTo: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No listings yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final listings = snapshot.data!.docs;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing =
                      listings[index].data() as Map<String, dynamic>;
                  final listingId = listings[index].id;
                  final title = listing['title'] ?? 'No Title';
                  final price = (listing['price'] ?? 0).toDouble();
                  final images = listing['images'] as List<dynamic>? ?? [];
                  final imageUrl = images.isNotEmpty ? images[0] : '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemDetailsScreen(listingId: listingId),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.edit, size: 18),
                                        color: const Color(0xFFD4A017),
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          _showEditDialog(
                                            listingId,
                                            title,
                                            price,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.2,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 18,
                                        ),
                                        color: Colors.red,
                                        padding: const EdgeInsets.all(8),
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          _showDeleteDialog(listingId, title);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    ).then((_) => _loadCounts());
  }

  void _showDeleteDialog(String listingId, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _firestore.collection('listings').doc(listingId).delete();
              _loadCounts();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing deleted successfully')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    String listingId,
    String currentTitle,
    double currentPrice,
  ) {
    final titleController = TextEditingController(text: currentTitle);
    final priceController = TextEditingController(
      text: currentPrice.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Listing'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price (RM)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String newTitle = titleController.text.trim();
              String priceText = priceController.text.trim();

              if (newTitle.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Title cannot be empty')),
                );
                return;
              }

              double? newPrice = double.tryParse(priceText);
              if (newPrice == null || newPrice <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid price')),
                );
                return;
              }

              Navigator.pop(context);

              await _firestore.collection('listings').doc(listingId).update({
                'title': newTitle,
                'price': newPrice,
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSavedItems() {
    final user = _auth.currentUser;
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Saved Items'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(user.uid)
                .collection('savedItems')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No saved items yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              final savedItems = snapshot.data!.docs;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: savedItems.length,
                itemBuilder: (context, index) {
                  final savedItem =
                      savedItems[index].data() as Map<String, dynamic>;
                  final listingId = savedItem['listingId'] ?? '';

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore
                        .collection('listings')
                        .doc(listingId)
                        .get(),
                    builder: (context, listingSnapshot) {
                      if (!listingSnapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        );
                      }

                      final listing =
                          listingSnapshot.data!.data() as Map<String, dynamic>?;
                      if (listing == null) {
                        return Container();
                      }

                      final name = listing['name'] ?? 'No Name';
                      final price = listing['price'] ?? 0.0;
                      final images = listing['images'] as List<dynamic>? ?? [];
                      final imageUrl = images.isNotEmpty ? images[0] : '';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemDetailsScreen(listingId: listingId),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: imageUrl.isNotEmpty
                                    ? Image.network(
                                        imageUrl,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    ).then((_) => _loadCounts());
  }
}
