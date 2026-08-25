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
  // String? threadId;

  ChatBloc({
    required InnerChatHandler chatHandler,
    required AuthInnerInterface authInterface,
  }) : _authInterface = authInterface,
       _chatHandler = chatHandler,
       super(const ChatState()) {
    //streaming -----------------------------------------------------------------------

    // auth stream -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    String? currentUserId;
    _authSubscription = _authInterface.userStream.listen((user) {
      if (currentUserId != user.id) {
        currentUserId = user.id;
        add(ChatEventFlushData());
        add(ChatEventUnsubscribe());
        // add(ChatEventInitializeThread(userId: user.id));
      }
    });

    // Subscribe to Real-Time Messages ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventSubscribeToMessages>((event, emit) async {
      developer.log('---');
      developer.log('--- ChatEventSubscribeToMessages fired');
      developer.log('---');
      _messagesSubscription?.cancel();
      emit(
        state.copyWith(isSubscribed: false, status: ChatStates.unsubscribed),
      );
      try {
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
        emit(state.copyWith(isSubscribed: true, status: ChatStates.subscribed));
      } catch (e) {
        emit(state.copyWith(isSubscribed: false, status: ChatStates.error));
        rethrow;
      }
    });

    // Handle Incoming Stream Updates ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventMessagesUpdated>((event, emit) {
      emit(
        state.copyWith(
          isSubscribed: true,
          messages: event.messages,
          status: ChatStates.messagesUpdated,
        ),
      );
      // add(ChatEventMarkAsRead());
    });

    on<ChatEventUnsubscribe>((event, emit) {
      emit(
        state.copyWith(isSubscribed: false, status: ChatStates.unsubscribed),
      );
      _chatHandler.unsubscribeFromMessages();
    });

    //streaming -----------------------------------------------------------------------

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

    // Send Message ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventSendMessage>((event, emit) async {
      developer.log('---');
      developer.log('--- ChatEventSendMessage fired');
      developer.log('---');
      // final currentThread = state.activeThread;
      // if (currentThread == null) return;
      emit(state.copyWith(status: ChatStates.loading));
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
            status: ChatStates.messageSentFailed,
            errorMessage: 'Failed to send message',
          ),
        );
        rethrow;
      }
    });

    on<ChatEventSendShadowMessage>((event, emit) async {
      developer.log('---');
      developer.log('--- ChatEventSendShadowMessage fired');
      developer.log('---');
      emit(state.copyWith(status: ChatStates.loading));
      try {
        String? threadId;
        threadId = state.activeThread?.id;
        if (threadId == null) {
          final thread = await _chatHandler.getOrCreateThread(
            userId: event.senderId,
          );
          if (thread != null) threadId = thread.id;
          if (threadId == null) throw Exception('no thread');
        }
        await _chatHandler.sendShadowMessage(
          threadId: threadId,
          senderId: event.senderId,
          content: event.content,
          shadowContent: event.shadowContent,
        );
        emit(state.copyWith(status: ChatStates.shadowMessageSent));
      } catch (e) {
        emit(
          state.copyWith(
            status: ChatStates.shadowMessageSentFailed,
            errorMessage: 'Failed to send shadow message: $e',
          ),
        );
        rethrow;
      }
    });

    // Flush Data ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventFlushData>((event, emit) {
      developer.log('---');
      developer.log('--- ChatEventFlushData fired');
      developer.log('---');
      _messagesSubscription?.cancel();
      _messagesSubscription = null;
      emit(
        const ChatState(
          activeThread: null,
          messages: null,
          errorMessage: null,
          isSubscribed: false,
          status: ChatStates.flushed,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    developer.log(
      '--- ChatBloc closing: canceling real-time message stream ---',
    );
    _messagesSubscription?.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
