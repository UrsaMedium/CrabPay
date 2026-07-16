import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';
import 'package:equatable/equatable.dart';

enum ChatStates {
  initial,
  loading,
  threadInitialized,
  messagesUpdated,
  messageSent,
  messageSendFailed,
  flushed,
  error,
}

class ChatState extends Equatable {
  final ChatStates status;
  final SupportThread? activeThread;
  final List<ChatMessage>? messages;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStates.initial,
    this.activeThread,
    this.messages,
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStates? status,
    SupportThread? activeThread,
    List<ChatMessage>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      activeThread: activeThread ?? this.activeThread,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, activeThread, messages, errorMessage];
}
