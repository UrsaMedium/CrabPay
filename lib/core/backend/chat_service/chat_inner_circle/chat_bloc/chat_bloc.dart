import 'dart:async';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_event.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_state.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/inner_chat_handler.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AuthInnerInterface _authInterface;
  late final StreamSubscription<AppAuthUser> _authSubscription;
  final InnerChatHandler _chatHandler;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  ChatBloc({
    required InnerChatHandler chatHandler,
    required AuthInnerInterface authInterface,
  }) : _authInterface = authInterface,
       _chatHandler = chatHandler,
       super(const ChatState()) {
    // Initialize Thread ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventInitializeThread>((event, emit) async {
      developer.log('---');
      developer.log('--- ChatEventInitializeThread fired');
      developer.log('---');
      try {
        emit(state.copyWith(status: ChatStates.loading));
        final thread = await _chatHandler.getOrCreateThread(
          userId: event.userId,
        );

        if (thread != null) {
          emit(
            state.copyWith(
              activeThread: thread,
              status: ChatStates.threadInitialized,
            ),
          );
          add(ChatEventSubscribeToMessages(threadId: thread.id));
        } else {
          emit(
            state.copyWith(
              status: ChatStates.error,
              errorMessage: 'Could not initialize chat thread.',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(status: ChatStates.error, errorMessage: e.toString()),
        );
        rethrow;
      }
    });

    // Subscribe to Real-Time Messages ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventSubscribeToMessages>((event, emit) {
      developer.log('---');
      developer.log('--- ChatEventSubscribeToMessages fired');
      developer.log('---');
      _messagesSubscription?.cancel();
      _messagesSubscription = _chatHandler
          .subscribeToMessages(threadId: event.threadId)
          .listen(
            (messages) {
              add(ChatEventMessagesUpdated(messages: messages));
            },
            onError: (error) {
              developer.log('Chat stream error: $error');
            },
          );
    });

    // Handle Incoming Stream Updates ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventMessagesUpdated>((event, emit) {
      emit(
        state.copyWith(
          messages: event.messages,
          status: ChatStates.messagesUpdated,
        ),
      );
      add(ChatEventMarkAsRead());
    });

    // Send Message ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventSendMessage>((event, emit) async {
      developer.log('---');
      developer.log('--- ChatEventSendMessage fired');
      developer.log('---');
      // final currentThread = state.activeThread;
      // if (currentThread == null) return;

      try {
        await _chatHandler.sendMessage(
          threadId: event.threadId,
          senderId: event.senderId,
          content: event.content,
        );
        emit(state.copyWith(status: ChatStates.messageSent));
      } catch (e) {
        emit(
          state.copyWith(
            status: ChatStates.messageSendFailed,
            errorMessage: 'Failed to send message',
          ),
        );
        rethrow;
      }
    });

    // Fetch all threads ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventFetchAllThreads>((event, emit) async {
      emit(state.copyWith(status: ChatStates.loading));
      try {
        final allThreads = await _chatHandler.getAllThreads();
        if (allThreads.isEmpty) {
          emit(state.copyWith(status: ChatStates.error, allThreads: null));
        } else {
          emit(
            state.copyWith(
              status: ChatStates.fetchedAllThreads,
              allThreads: allThreads,
            ),
          );
        }
      } catch (e) {
        emit(state.copyWith(status: ChatStates.error));
        rethrow;
      }
    });

    // Mark Messages as Read ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventMarkAsRead>((event, emit) async {
      final currentThread = state.activeThread;
      if (currentThread == null) return;
      try {
        await _chatHandler.markMessagesAsRead(threadId: currentThread.id);
      } catch (e) {
        developer.log('Could not mark messages as read: $e');
      }
    });

    // Flush Data ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventFlushData>((event, emit) {
      developer.log('---');
      developer.log('--- ChatEventFlushData fired');
      developer.log('---');
      _messagesSubscription?.cancel();
      _messagesSubscription = null;
      emit(const ChatState(status: ChatStates.flushed));
    });

    _authSubscription = _authInterface.userStream.listen((user) {
      add(ChatEventFlushData());
      add(ChatEventInitializeThread(userId: user.id));
    });
  }

  @override
  Future<void> close() {
    developer.log('--- ChatBloc closing: canceling real-time message stream ---');
    _messagesSubscription?.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
