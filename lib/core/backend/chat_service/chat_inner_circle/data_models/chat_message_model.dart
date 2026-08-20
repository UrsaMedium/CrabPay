class ChatMessage {
  final String id;
  final String threadId;
  final String senderId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final bool? sending;

  ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.sending,
  });

  factory ChatMessage.intial() => ChatMessage(
    id: '',
    threadId: '',
    senderId: '',
    content: '',
    isRead: false,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  );
}
