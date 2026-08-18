import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';

abstract class InnerChatHandler {
  Future<SupportThread?> getOrCreateThread({required String userId});
  // Future<SupportThread?> getThread({required String userId});
  // Future<SupportThread?> createThread({required String userId});
  Stream<List<ChatMessage>> subscribeToMessages({required String threadId});
  void unsubscribeFromMessages();
  Future<void> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
  });
  Future<void> sendShadowMessage({
    required String content,
    required String shadowContent,
    required String senderId,
    required String threadId,
  });
  Future<void> markMessagesAsRead({required String threadId});
}
