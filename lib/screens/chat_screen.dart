import 'package:flutter/material.dart';
import 'home_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Messages',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search conversations...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Conversations List
            Expanded(
              child: ListView(
                children: [ // adjust the actual conversation data respectively
                  _buildConversationTile(
                    initial: 'A',
                    name: 'Ahmad Faisal',
                    message: 'Is the MacBook still available?',
                    time: '2m ago',
                    unreadCount: 2,
                    productImage: 'macbook',
                    onTap: () {
                      // TODO: Navigate to chat conversation screen
                    },
                  ),
                  _buildConversationTile(
                    initial: 'N',
                    name: 'Nurul Izzah',
                    message: 'Can we meet tomorrow at KENMS?',
                    time: '1h ago',
                    unreadCount: 0,
                    productImage: 'book',
                    onTap: () {
                      // TODO: Navigate to chat conversation screen
                    },
                  ),
                  _buildConversationTile(
                    initial: 'M',
                    name: 'Muhammad Hafiz',
                    message: 'Thanks! The book is in great condition 👍',
                    time: '3h ago',
                    unreadCount: 0,
                    productImage: 'book',
                    onTap: () {
                      // TODO: Navigate to chat conversation screen
                    },
                  ),
                  _buildConversationTile(
                    initial: 'S',
                    name: 'Siti Aminah',
                    message: 'I can do RM250 for the desk',
                    time: '1d ago',
                    unreadCount: 1,
                    productImage: 'table',
                    onTap: () {
                      // TODO: Navigate to chat conversation screen
                    },
                  ),
                  _buildConversationTile(
                    initial: 'I',
                    name: 'Ismail Rahman',
                    message: 'Deal! When can you deliver?',
                    time: '2d ago',
                    unreadCount: 0,
                    productImage: 'headphone',
                    onTap: () {
                      // TODO: Navigate to chat conversation screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile({
    required String initial,
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required String productImage,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withValues(alpha: 0.2),
        highlightColor: Colors.grey.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: [
              // Avatar with badge
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getAvatarColor(initial),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4A017),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 15),
              
              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: unreadCount > 0 ? Colors.black87 : Colors.grey[600],
                        fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              
              // Product image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/chat_screen/$productImage.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // change this to an actual avatar picture or link later
  Color _getAvatarColor(String initial) {
    // Generate different colors based on initial
    final colors = [
      const Color(0xFFF2D06B),
      const Color(0xFF8B9DC3),
      const Color(0xFFDDA15E),
      const Color(0xFF6C757D),
      const Color(0xFFC08552),
    ];
    final index = initial.codeUnitAt(0) % colors.length;
    return colors[index];
  }
}

