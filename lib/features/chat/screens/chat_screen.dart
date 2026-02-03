import 'package:flutter/material.dart';
import '../../../core/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = getDummyChatMessages();
  String _searchQuery = '';

  List<ChatMessage> get _filteredMessages {
    if (_searchQuery.isEmpty) return _messages;
    return _messages.where((msg) {
      return msg.userName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          msg.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: const Text(
                'Messages',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: const InputDecoration(
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
              child: _filteredMessages.isEmpty
                  ? const Center(
                      child: Text(
                        'No conversations found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredMessages.length,
                      itemBuilder: (context, index) {
                        return _buildConversationTile(_filteredMessages[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationTile(ChatMessage message) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
        },
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
                    backgroundColor: _getAvatarColor(message.initial),
                    child: Text(
                      message.initial,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (message.unreadCount > 0)
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
                            '${message.unreadCount}',
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
                        Expanded(
                          child: Text(
                            message.userName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: message.unreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          message.timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.lastMessage,
                      style: TextStyle(
                        fontSize: 14,
                        color: message.unreadCount > 0
                            ? Colors.black87
                            : Colors.grey[600],
                        fontWeight: message.unreadCount > 0
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.productName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );  }

  // Generate different colors based on initial
  Color _getAvatarColor(String initial) {
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

