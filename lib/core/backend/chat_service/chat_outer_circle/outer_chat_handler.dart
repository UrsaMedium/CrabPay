import 'dart:async';

import 'package:crabpay/core/app_services/app_lifecycle.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/support_thread_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/inner_chat_handler.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:retry/retry.dart';

class OuterChatHandlerWithSupabase implements InnerChatHandler {
  final SupabaseClient _client = Supabase.instance.client;
  final retryer = const RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(microseconds: 500),
  );

  //streaming--------------------------------------------------------------------
  StreamSubscription? _appLifecycleSub;
  StreamSubscription? _messagesSub;
  String? _threadId;
  bool keepAlive = false;

  final _messagesControler = StreamController<List<ChatMessage>>.broadcast();

  final AppLifecycleService _appLifecycleService;
  OuterChatHandlerWithSupabase({
    required AppLifecycleService appLifecycleService,
  }) : _appLifecycleService = appLifecycleService {
    _initAppLifecycleService();
  }

  void _initAppLifecycleService() {
    _appLifecycleSub = _appLifecycleService.appStateStream.listen((state) {
      if (state == AppState.active && _threadId != null && keepAlive) {
        _connectToSupabase(_threadId!);
      } else if (state == AppState.paused) {
        _disconnectFromSupabase();
      }
    });
  }

  @override
  Stream<List<ChatMessage>> subscribeToMessages({required String threadId}) {
    _threadId = threadId;
    keepAlive = true;

    _disconnectFromSupabase();
    _connectToSupabase(threadId);

    return _messagesControler.stream;
  }

  void _connectToSupabase(String threadId) {
    if (_messagesSub != null) return;

    try {
      _client
          .from('chat_messages')
          .stream(primaryKey: ['id'])
          .eq('thread_id', threadId)
          .order('created_at', ascending: true)
          .map((List<Map<String, dynamic>> data) {
            return data
                .map(
                  (json) => ChatMessage(
                    id: json['id'] as String,
                    threadId: json['thread_id'] as String,
                    senderId: json['sender_id'] as String,
                    content: json['content'] as String,
                    isRead: json['is_read'] as bool? ?? false,
                    createdAt: DateTime.parse(json['created_at'] as String),
                  ),
                )
                .toList();
          })
          .handleError((error, stackTrace) {
            getIt<InnerLoggerHandler>().recordException(
              error: 'Runtime Stream Error in subscribeToMessages: $error',
              stackTrace: stackTrace is StackTrace
                  ? stackTrace
                  : StackTrace.current,
            );
            _messagesControler.addError(error);
          }) 
          .listen(
            (messages) {
              _messagesControler.add(messages);
            },
            onError: (error) {
              _messagesControler.addError(error);
            },
          );
    } catch (e, s) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'Failed synchronous setup: userCartItemAmountStream',
        stackTrace: s,
      );
      _messagesControler.addError(e);
    }
  }

  @override
  void unsubscribeFromMessages() {
    _disconnectFromSupabase();
    keepAlive = false;
  }

  void _disconnectFromSupabase() {
    _messagesSub?.cancel();
    _messagesSub = null;
  }

  void dispose() {
    _disconnectFromSupabase();
    _appLifecycleSub?.cancel();
    _messagesControler.close();
  }

  //streaming--------------------------------------------------------------------

  @override
  Future<SupportThread?> getOrCreateThread({required String userId}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'Get Or Create Thread',
        category: 'Chat Service',
        data: {'userId': userId},
      );
      return await retryer.retry(() async {
        final existing = await _client
            .from('support_threads')
            .select()
            .eq('user_id', userId)
            .maybeSingle();

        if (existing != null) {
          return SupportThread(
            id: existing['id'] as String,
            userId: existing['user_id'] as String,
            status: existing['status'] as String,
          );
        }

        final created = await _client
            .from('support_threads')
            .insert({'user_id': userId, 'status': 'open'})
            .select()
            .single();

        return SupportThread(
          id: created['id'] as String,
          userId: created['user_id'] as String,
          status: created['status'] as String,
        );
      });
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'failed exe: getOrCreateThread',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      debugPrint('Failed to get or create support thread: $e');
      Fluttertoast.showToast(msg: 'Failed to get or create support thread');
      rethrow;
    }
  }

  @override
  Future<void> markMessagesAsRead({required String threadId}) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'exe: Mark Messages As Read',
        category: 'Chat Service',
        data: {'threadId': threadId},
      );
      // Mark all messages in this thread NOT sent by the current user as read
      final currentUserId = _client.auth.currentUser?.id;
      if (currentUserId == null) return;

      await _client
          .from('chat_messages')
          .update({'is_read': true})
          .eq('thread_id', threadId)
          .neq('sender_id', currentUserId);
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'failed exe: markMessagesAsRead',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      debugPrint('Failed to mark messages as read: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendMessage({
    required String threadId,
    required String senderId,
    required String content,
  }) async {
    try {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message: 'exe: Send Message',
        category: 'Chat Service',
        data: {'threadId': threadId, 'senderId': senderId, 'content': content},
      );
      await retryer.retry(() async {
        await _client.from('chat_messages').insert({
          'thread_id': threadId,
          'sender_id': senderId,
          'content': content,
        });
      });
    } catch (e) {
      getIt<InnerLoggerHandler>().recordException(
        error: 'failed exe: sendMessage',
        stackTrace: StackTrace.fromString(e.toString()),
      );
      debugPrint('Failed to send message: $e');
      Fluttertoast.showToast(msg: 'Failed to send message. Please try again.');
      rethrow;
    }
  }
}
