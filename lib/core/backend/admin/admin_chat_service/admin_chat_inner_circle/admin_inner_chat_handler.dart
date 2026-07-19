import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';

abstract class AdminInnerChatHandler {
  Future<SupportThread?> getOrCreateThreadAdmin({required String userId});
  Future<List<SupportThread>> getAllThreadsAdmin();
  Stream<List<ChatMessage>> subscribeToMessagesAdmin({required String threadId});
  Future<void> sendMessageAdmin({
    required String threadId,
    required String senderId,
    required String content,
  });

  Future<void> markMessagesAsReadAdmin({required String threadId});
}
