import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_user.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_event.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_state.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminSupportChatView extends StatefulWidget {
  static const routeName = 'admin_support_chat_view';
  final String? threadId;
  const AdminSupportChatView({super.key, this.threadId});

  @override
  State<AdminSupportChatView> createState() => _AdminSupportChatViewState();
}

class _AdminSupportChatViewState extends State<AdminSupportChatView> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    if (widget.threadId != null) {
      context.read<ChatBloc>().add(
        ChatEventSubscribeToMessages(threadId: widget.threadId!),
      );
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message:
            'AdminSupportChatView initState: Subscribed to messages for threadId: ${widget.threadId}',
      );
    } else {
      getIt<InnerLoggerHandler>().logBreadcrumb(
        message:
            'AdminSupportChatView initState: No threadId provided, cannot subscribe to messages.',
      );
      context.pop();
    }
    super.initState();
  }

  void _onBackPressed(BuildContext context) {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'AdminSupportChatView: onBackButtonPressed',
    );
    context.read<ChatBloc>().add(
      ChatEventSubscribeToMessages(
        threadId: context.read<ChatBloc>().state.activeThread!.id,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, chatState) {
        List<ChatMessage> messages = chatState.messages ?? [];
        return MaterialAdminSupportPageView(
          onBackPressed: () => _onBackPressed(context),
          currentUser: context.read<AuthBloc>().state.currentUser,
          messages: messages,
          textEditingController: _textEditingController,
          onSendPressed: () {
            context.read<ChatBloc>().add(
              ChatEventSendMessage(
                content: _textEditingController.text,
                senderId: context.read<AuthBloc>().state.currentUser.id,
                threadId: widget.threadId!,
              ),
            );
            _textEditingController.clear();
          },
        );
      },
    );
  }
}

class MaterialAdminSupportPageView extends StatelessWidget {
  final List<ChatMessage> messages;
  final TextEditingController textEditingController;
  final VoidCallback onSendPressed;
  final VoidCallback onBackPressed;
  final AppAuthUser currentUser;
  const MaterialAdminSupportPageView({
    super.key,
    required this.messages,
    required this.textEditingController,
    required this.onSendPressed,
    required this.currentUser,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 4, right: 4),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final isMe = messages[index].senderId == currentUser.id;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 8,
                  ),
                  child: Align(
                    alignment: isMe
                        ? AlignmentGeometry.centerRight
                        : AlignmentGeometry.centerLeft,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(30),
                      ),
                      color: context.appColorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Text(
                          messages[index].content,
                          style: TextStyle(
                            color: context.appColorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 8,
              right: 8,
              left: 8,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: .multiline,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.appColorScheme.primaryFixed,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.appColorScheme.primaryFixed,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        hint: Text('Type your question...'),
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: IconButton(
                      onPressed: onSendPressed,
                      icon: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
