import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEventAdmin extends Equatable {
  const ChatEventAdmin  ();

  @override
  List<Object?> get props => [];
}

class ChatEventInitializeThreadAdmin extends ChatEventAdmin {
  final String userId;
  const ChatEventInitializeThreadAdmin({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ChatEventSubscribeToMessagesAdmin extends ChatEventAdmin {
  final String threadId;
  const ChatEventSubscribeToMessagesAdmin({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

class ChatEventMessagesUpdatedAdmin extends ChatEventAdmin {
  final List<ChatMessage> messages;
  const ChatEventMessagesUpdatedAdmin({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatEventSendMessageAdmin extends ChatEventAdmin {
  final String content;
  final String senderId;
  final String threadId;
  const ChatEventSendMessageAdmin({
    required this.content,
    required this.senderId,
    required this.threadId,
  });

  @override
  List<Object?> get props => [content, senderId, threadId];
}

class ChatEventMarkAsReadAdmin extends ChatEventAdmin {}

class ChatEventFlushDataAdmin extends ChatEventAdmin {}

class ChatEventFetchAllThreadsAdmin extends ChatEventAdmin {}
