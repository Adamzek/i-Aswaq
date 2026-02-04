import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../chat/screens/conversation_screen.dart';

class ItemDetailsScreen extends StatefulWidget {
  final String listingId;

  const ItemDetailsScreen({
    super.key,
    required this.listingId,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  void _checkIfSaved() async {
    final user = auth.currentUser;
    if (user == null) return;

    final doc = await firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedItems')
        .doc(widget.listingId)
        .get();

    setState(() {
      isFavorite = doc.exists;
    });
  }

  void _toggleFavorite() async {
    final user = auth.currentUser;
    if (user == null) return;

    final savedItemRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('savedItems')
        .doc(widget.listingId);

    if (isFavorite) {
      await savedItemRef.delete();
      setState(() {
        isFavorite = false;
      });
    } else {
      await savedItemRef.set({
        'listingId': widget.listingId,
        'savedAt': FieldValue.serverTimestamp(),
      });
      setState(() {
        isFavorite = true;
      });
    }
  }

  void _chatWithSeller(
    String sellerId,
    String sellerName,
    String listingId,
    String productName,
    double productPrice,
    String productImage,
  ) async {
    String currentUserId = auth.currentUser!.uid;
    String chatId = 'chat_${currentUserId}_$sellerId';

    // Create or update chat document
    await firestore.collection('chats').doc(chatId).set({
      'participants': [currentUserId, sellerId],
      'listingId': listingId,
      'productName': productName,
      'productPrice': productPrice,
      'productImage': productImage,
      'otherUserName': sellerName,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationScreen(
          chatId: chatId,
          userName: sellerName,
          userInitial: sellerName.isNotEmpty ? sellerName[0].toUpperCase() : 'S',
          listingId: listingId,
          productName: productName,
          productPrice: productPrice,
          productImage: productImage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.collection('listings').doc(widget.listingId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading item'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Item not found'));
          }

          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          String title = data['title'] ?? 'No Title';
          double price = (data['price'] ?? 0).toDouble();
          String description = data['description'] ?? 'No description';
          String condition = data['condition'] ?? 'Used';
          String category = data['category'] ?? 'Other';
          String seller = data['seller'] ?? 'Unknown';
          String userId = data['userId'] ?? '';
          List<dynamic> images = data['images'] ?? [];
          String imageUrl = images.isNotEmpty ? images[0] : '';
          String createdAt = data['createdAt'] ?? '';

          String postedTime = _getPostedTime(createdAt);

          return Stack(
            children: [
              // Main scrollable content
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Top Image Section
                    Stack(
                      children: [
                        Container(
                          height: screenHeight * 0.4,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: Colors.grey[600],
                                  ),
                                ),
                        ),
                        // Back button
                        Positioned(
                          top: 40,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.black),
                            ),
                          ),
                        ),
                        // Favorite button
                        Positioned(
                          top: 40,
                          right: 16,
                          child: GestureDetector(
                            onTap: _toggleFavorite,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content Container
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tags Row
                              Row(
                                children: [
                                  _buildTag(condition, Colors.grey[300]!),
                                  const SizedBox(width: 8),
                                  _buildTag(category, const Color(0xFFFFF9E7)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Title
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Price
                              Text(
                                'RM ${price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD4A017),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Seller Card
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xFFD4A017).withValues(alpha: 0.2),
                                      child: Text(
                                        seller.isNotEmpty ? seller[0].toUpperCase() : 'S',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD4A017),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                seller.split('@')[0],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.verified,
                                                color: Color(0xFFD4A017),
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'View Profile',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Description
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Posted time
                              Text(
                                postedTime,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Fixed Chat Button at Bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _chatWithSeller(
                        userId,
                        seller,
                        widget.listingId,
                        title,
                        price,
                        imageUrl,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A017),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Chat with Seller',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getPostedTime(String createdAt) {
    if (createdAt.isEmpty) return 'Posted recently';

    try {
      DateTime posted = DateTime.parse(createdAt);
      DateTime now = DateTime.now();
      Duration difference = now.difference(posted);

      if (difference.inDays > 0) {
        return 'Posted ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return 'Posted ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return 'Posted ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Posted just now';
      }
    } catch (e) {
      return 'Posted recently';
    }
  }
}
