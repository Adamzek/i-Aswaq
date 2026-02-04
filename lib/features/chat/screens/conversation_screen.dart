import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../listing/screens/item_details_screen.dart';

class ConversationScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String userInitial;
  final String listingId;
  final String productName;
  final double productPrice;
  final String productImage;

  const ConversationScreen({
    super.key,
    required this.chatId,
    required this.userName,
    required this.userInitial,
    required this.listingId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    String currentUserId = auth.currentUser!.uid;

    firestore
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': messageText,
      'senderId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withValues(alpha: 0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: _getAvatarColor(widget.userInitial),
              child: Text(
                widget.userInitial,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Active now',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
      body: Column(
        children: [
          // Product card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.productImage.isNotEmpty
                      ? Image.network(
                          widget.productImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[600],
                                size: 30,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM ${widget.productPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD4A017),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsScreen(
                          listingId: widget.listingId,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'View',
                    style: TextStyle(
                      color: Color(0xFFD4A017),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;
                String currentUserId = auth.currentUser!.uid;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = messages[index].data() as Map<String, dynamic>;
                    String text = data['text'] ?? '';
                    String senderId = data['senderId'] ?? '';
                    Timestamp? timestamp = data['timestamp'];

                    bool isSentByMe = senderId == currentUserId;
                    String time = '';
                    if (timestamp != null) {
                      DateTime dateTime = timestamp.toDate();
                      time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
                    }

                    return _buildMessageBubble(
                      text: text,
                      isSentByMe: isSentByMe,
                      time: time,
                    );
                  },
                );
              },
            ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD4A017),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required bool isSentByMe,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: _getAvatarColor(widget.userInitial),
              child: Text(
                widget.userInitial,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSentByMe ? const Color(0xFFD4A017) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSentByMe ? 16 : 4),
                  bottomRight: Radius.circular(isSentByMe ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSentByMe ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSentByMe
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSentByMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

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
