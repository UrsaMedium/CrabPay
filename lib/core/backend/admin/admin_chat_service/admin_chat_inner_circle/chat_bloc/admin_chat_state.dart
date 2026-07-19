import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';
import 'package:equatable/equatable.dart';

enum ChatStatesAdmin {
  initial,
  loading,
  threadInitialized,
  messagesUpdated,
  messageSent,
  messageSendFailed,
  fetchedAllThreads,
  flushed,
  error,
}

class ChatStateAdmin extends Equatable {
  final ChatStatesAdmin status;
  final SupportThread? activeThread;
  final List<SupportThread>? allThreads;
  final List<ChatMessage>? messages;
  final String? errorMessage;

  const ChatStateAdmin({
    this.status = ChatStatesAdmin.initial,
    this.activeThread,
    this.messages,
    this.errorMessage,
    this.allThreads,
  });

  ChatStateAdmin copyWith({
    ChatStatesAdmin? status,
    SupportThread? activeThread,
    List<ChatMessage>? messages,
    String? errorMessage,
    List<SupportThread>? allThreads,
  }) {
    return ChatStateAdmin(
      status: status ?? this.status,
      activeThread: activeThread ?? this.activeThread,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      allThreads: allThreads ?? this.allThreads,
    );
  }

  @override
  List<Object?> get props => [
    status,
    activeThread,
    messages,
    errorMessage,
    allThreads,
  ];
}
