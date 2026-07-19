import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_event.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_state.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/data_models/chat_message_model.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/main.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/support_page/material_support_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportPageDriver extends StatefulWidget {
  const SupportPageDriver({super.key});

  @override
  State<SupportPageDriver> createState() => _SupportPageDriverState();
}

class _SupportPageDriverState extends State<SupportPageDriver> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'SupportPageDriver initState',
    );
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, chatState) {
        List<ChatMessage> messages = chatState.messages ?? [];
        return MaterialSupportPageView(
          currentUser: context.read<AuthBloc>().state.currentUser,
          messages: messages,
          textEditingController: _textEditingController,
          onSendPressed: () {
            context.read<ChatBloc>().add(
              ChatEventSendMessage(
                threadId: context.read<ChatBloc>().state.activeThread!.id,
                content: _textEditingController.text,
                senderId: context.read<AuthBloc>().state.currentUser.id,
              ),
            );
            _textEditingController.clear();
          },
        );
      },
    );
  }
}
