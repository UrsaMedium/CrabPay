import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatEventInitializeThread extends ChatEvent {
  final String userId;
  const ChatEventInitializeThread({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ChatEventSubscribeToMessages extends ChatEvent {
  final String threadId;
  const ChatEventSubscribeToMessages({required this.threadId});

  @override
  List<Object?> get props => [threadId];
}

class ChatEventMessagesUpdated extends ChatEvent {
  final List<ChatMessage> messages;
  const ChatEventMessagesUpdated({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatEventSendMessage extends ChatEvent {
  final String content;
  final String senderId;
  final String threadId;
  const ChatEventSendMessage({
    required this.content,
    required this.senderId,
    required this.threadId,
  });

  @override
  List<Object?> get props => [content, senderId, threadId];
}

class ChatEventMarkAsRead extends ChatEvent {}

class ChatEventFlushData extends ChatEvent {}

class ChatEventFetchAllThreads extends ChatEvent {}
