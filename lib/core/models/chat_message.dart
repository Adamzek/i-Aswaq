class ChatMessage {
  final String id;
  final String userName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final String productName;

  ChatMessage({
    required this.id,
    required this.userName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.productName,
  });

  String get initial => userName.isNotEmpty ? userName[0].toUpperCase() : '?';
}

List<ChatMessage> getDummyChatMessages() {
  return [
    ChatMessage(
      id: '1',
      userName: 'Ahmad Faisal',
      lastMessage: 'Is the MacBook still available?',
      timeAgo: '2m ago',
      unreadCount: 2,
      productName: 'MacBook Pro',
    ),
    ChatMessage(
      id: '2',
      userName: 'Nurul Izzah',
      lastMessage: 'Can we meet tomorrow at KENMS?',
      timeAgo: '1h ago',
      unreadCount: 0,
      productName: 'Calculus Book',
    ),
    ChatMessage(
      id: '3',
      userName: 'Muhammad Hafiz',
      lastMessage: 'Thanks! The book is in great condition 👍',
      timeAgo: '3h ago',
      unreadCount: 0,
      productName: 'Programming Book',
    ),
    ChatMessage(
      id: '4',
      userName: 'Siti Aminah',
      lastMessage: 'I can do RM250 for the desk',
      timeAgo: '1d ago',
      unreadCount: 1,
      productName: 'Study Desk',
    ),
    ChatMessage(
      id: '5',
      userName: 'Ismail Rahman',
      lastMessage: 'Deal! When can you deliver?',
      timeAgo: '2d ago',
      unreadCount: 0,
      productName: 'Headphones',
    ),
    ChatMessage(
      id: '6',
      userName: 'Fatimah Ali',
      lastMessage: 'Can I see more photos?',
      timeAgo: '3d ago',
      unreadCount: 0,
      productName: 'T-Shirt',
    ),
  ];
}
