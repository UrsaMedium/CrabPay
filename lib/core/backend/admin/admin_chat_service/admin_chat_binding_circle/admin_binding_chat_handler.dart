import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/admin_inner_chat_handler.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_outer_circle/admin_outer_chat_handler.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';

class AdminBindingChatHandler implements AdminInnerChatHandler {
  final AdminInnerChatHandler chatHandler;

  AdminBindingChatHandler({required this.chatHandler});

  factory AdminBindingChatHandler.chatService() => AdminBindingChatHandler(
    chatHandler: (AdminOuterChatHandlerWithSupabase()),
  );

  @override
  Future<SupportThread?> getOrCreateThreadAdmin({required String userId}) =>
      chatHandler.getOrCreateThreadAdmin(userId: userId);

  @override
  Future<void> markMessagesAsReadAdmin({required String threadId}) =>
      chatHandler.markMessagesAsReadAdmin(threadId: threadId);

  @override
  Future<void> sendMessageAdmin({
    required String threadId,
    required String senderId,
    required String content,
  }) => chatHandler.sendMessageAdmin(
    threadId: threadId,
    senderId: senderId,
    content: content,
  );

  @override
  Stream<List<ChatMessage>> subscribeToMessagesAdmin({
    required String threadId,
  }) => chatHandler.subscribeToMessagesAdmin(threadId: threadId);

  @override
  Future<List<SupportThread>> getAllThreadsAdmin() =>
      chatHandler.getAllThreadsAdmin();
}
