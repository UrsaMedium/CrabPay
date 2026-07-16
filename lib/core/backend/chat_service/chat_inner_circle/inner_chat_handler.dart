import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';

abstract class InnerChatHandler {
  Future<SupportThread?> getOrCreateThread({required String userId});
  Future<List<SupportThread>> getAllThreads();
  Stream<List<ChatMessage>> subscribeToMessages({required String threadId});
  Future<void> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
  });

  Future<void> markMessagesAsRead({required String threadId});
}
