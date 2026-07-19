import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/admin_inner_chat_handler.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/chat_bloc/admin_chat_state.dart';
import 'package:crabpay/core/backend/admin/admin_chat_service/admin_chat_inner_circle/chat_bloc/adminchat_event.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_inner_interface.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';

class ChatBlocAdmin extends Bloc<ChatEventAdmin, ChatStateAdmin> {
  final AuthInnerInterface _authInterface;
  late final StreamSubscription<AppAuthUser> _authSubscription;
  final AdminInnerChatHandler _chatHandler;
  StreamSubscription<List<ChatMessage>>? _messagesSubscription;

  ChatBlocAdmin({
    required AdminInnerChatHandler chatHandlerAdmin,
    required AuthInnerInterface authInterface,
  }) : _authInterface = authInterface,
       _chatHandler = chatHandlerAdmin,
       super(const ChatStateAdmin()) {
    // Initialize Thread ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventInitializeThreadAdmin>((event, emit) async {
      print('---');
      print('--- ChatEventInitializeThreadAdmin fired');
      print('---');
      try {
        emit(state.copyWith(status: ChatStatesAdmin.loading));
        final thread = await _chatHandler.getOrCreateThreadAdmin(
          userId: event.userId,
        );

        if (thread != null) {
          emit(
            state.copyWith(
              activeThread: thread,
              status: ChatStatesAdmin.threadInitialized,
            ),
          );
          add(ChatEventSubscribeToMessagesAdmin(threadId: thread.id));
        } else {
          emit(
            state.copyWith(
              status: ChatStatesAdmin.error,
              errorMessage: 'Could not initialize chat thread.',
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(status: ChatStatesAdmin.error, errorMessage: e.toString()),
        );
        rethrow;
      }
    });

    // Subscribe to Real-Time Messages ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventSubscribeToMessagesAdmin>((event, emit) {
      print('---');
      print('--- ChatEventSubscribeToMessagesAdmin fired');
      print('---');
      _messagesSubscription?.cancel();
      _messagesSubscription = _chatHandler
          .subscribeToMessagesAdmin(threadId: event.threadId)
          .listen(
            (messages) {
              add(ChatEventMessagesUpdatedAdmin(messages: messages));
            },
            onError: (error) {
              print('Chat stream error: $error');
            },
          );
    });

    // Handle Incoming Stream Updates ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventMessagesUpdatedAdmin>((event, emit) {
      emit(
        state.copyWith(
          messages: event.messages,
          status: ChatStatesAdmin.messagesUpdated,
        ),
      );
      add(ChatEventMarkAsReadAdmin());
    });

    // Send Message ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventSendMessageAdmin>((event, emit) async {
      print('---');
      print('--- ChatEventSendMessageAdmin fired');
      print('---');
      // final currentThread = state.activeThread;
      // if (currentThread == null) return;

      try {
        await _chatHandler.sendMessageAdmin(
          threadId: event.threadId,
          senderId: event.senderId,
          content: event.content,
        );
        emit(state.copyWith(status: ChatStatesAdmin.messageSent));
      } catch (e) {
        emit(
          state.copyWith(
            status: ChatStatesAdmin.messageSendFailed,
            errorMessage: 'Failed to send message',
          ),
        );
        rethrow;
      }
    });

    // Fetch all threads ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventFetchAllThreadsAdmin>((event, emit) async {
      emit(state.copyWith(status: ChatStatesAdmin.loading));
      try {
        final allThreads = await _chatHandler.getAllThreadsAdmin();
        if (allThreads.isEmpty) {
          emit(state.copyWith(status: ChatStatesAdmin.error, allThreads: null));
        } else {
          emit(
            state.copyWith(
              status: ChatStatesAdmin.fetchedAllThreads,
              allThreads: allThreads,
            ),
          );
        }
      } catch (e) {
        emit(state.copyWith(status: ChatStatesAdmin.error));
        rethrow;
      }
    });

    // Mark Messages as Read ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventMarkAsReadAdmin>((event, emit) async {
      final currentThread = state.activeThread;
      if (currentThread == null) return;
      try {
        await _chatHandler.markMessagesAsReadAdmin(threadId: currentThread.id);
      } catch (e) {
        print('Could not mark messages as read: $e');
      }
    });

    // Flush Data ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    on<ChatEventFlushDataAdmin>((event, emit) {
      print('---');
      print('--- ChatEventFlushDataAdmin fired');
      print('---');
      _messagesSubscription?.cancel();
      _messagesSubscription = null;
      emit(const ChatStateAdmin(status: ChatStatesAdmin.flushed));
    });

    _authSubscription = _authInterface.userStream.listen((user) {
      add(ChatEventFlushDataAdmin());
      add(ChatEventInitializeThreadAdmin(userId: user.id));
    });
  }

  @override
  Future<void> close() {
    print('--- ChatBloc closing: canceling real-time message stream ---');
    _messagesSubscription?.cancel();
    _authSubscription.cancel();
    return super.close();
  }
}
