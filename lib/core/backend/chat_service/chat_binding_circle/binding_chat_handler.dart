import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/inner_chat_handler.dart';
import 'package:crabpay/core/backend/chat_service/chat_outer_circle/outer_chat_handler.dart';

class BindingChatHandler implements InnerChatHandler {
  final InnerChatHandler chatHandler;

  BindingChatHandler({required this.chatHandler});

  factory BindingChatHandler.chatService() =>
      BindingChatHandler(chatHandler: (OuterChatHandlerWithSupabase()));

  @override
  Future<SupportThread?> getOrCreateThread({required String userId}) =>
      chatHandler.getOrCreateThread(userId: userId);

  @override
  Future<void> markMessagesAsRead({required String threadId}) =>
      chatHandler.markMessagesAsRead(threadId: threadId);

  @override
  Future<void> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
  }) => chatHandler.sendMessage(
    threadId: threadId,
    senderId: senderId,
    content: content,
  );

  @override
  Stream<List<ChatMessage>> subscribeToMessages({required String threadId}) =>
      chatHandler.subscribeToMessages(threadId: threadId);
}
