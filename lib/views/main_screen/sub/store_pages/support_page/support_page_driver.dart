import 'package:crabpay/core/backend/authentication/auth_inner_circle/auth_bloc/auth_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_bloc.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_event.dart';
import 'package:crabpay/core/backend/chat_service/chat_inner_circle/chat_bloc/chat_state.dart';
import 'package:crabpay/core/backend/logger/logger_inner_handler/inner_logger_handler.dart';
import 'package:crabpay/core/utilities.dart';
import 'package:crabpay/views/app_routes/app_routes.dart';
import 'package:crabpay/views/main_screen/sub/store_pages/support_page/material_support_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportPageDriver extends StatefulWidget {
  static final routeName = AppRoutes.support.name;
  final String? message;
  const SupportPageDriver({super.key, this.message});

  @override
  State<SupportPageDriver> createState() => _SupportPageDriverState();
}

class _SupportPageDriverState extends State<SupportPageDriver> {
  late final TextEditingController _textEditingController;
  final ScrollController _scrollController = ScrollController();
  final double _bottomPadding = 300;

  @override
  void initState() {
    getIt<InnerLoggerHandler>().logBreadcrumb(
      message: 'SupportPageDriver initState',
    );
    debugPrint(widget.message);
    _textEditingController = TextEditingController(text: widget.message);
    // context.read<ChatBloc>().add(
    //   ChatEventInitializeThread(
    //     userId: context.read<AuthBloc>().state.currentUser.id,
    //   ),
    // );
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSendPressed(BuildContext context) {
    context.read<ChatBloc>().add(
      ChatEventSendMessage(
        threadId: context.read<ChatBloc>().state.activeThread!.id,
        content: _textEditingController.text.trim(),
        senderId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
    _textEditingController.clear();
  }

  void _onNewMessage(BuildContext context) {
    if (_scrollController.hasClients) {
      final currentOffset = _scrollController.offset;
      if (currentOffset <= _bottomPadding) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        context.read<SupportPageCubit>().showArrow();
      }
    }
  }

  void _onDownArrowPressed(BuildContext context) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    context.read<SupportPageCubit>().hideArrow();
  }

  void _onStartChatPressed(BuildContext context) {
    context.read<ChatBloc>().add(
      ChatEventInitializeThread(
        userId: context.read<AuthBloc>().state.currentUser.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupportPageCubit(),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          _onNewMessage(context);
        },
        builder: (context, chatState) {
          final messages = chatState.messages ?? [];
          return BlocBuilder<SupportPageCubit, SupportPageState>(
            builder: (context, viewState) {
              return MaterialSupportPageView(
                onDonwArrowPressed: () => _onDownArrowPressed(context),
                scrollController: _scrollController,
                currentUser: context.read<AuthBloc>().state.currentUser,
                messages: messages,
                textEditingController: _textEditingController,
                onSendPressed: () => _onSendPressed(context),
                showDownArrow: viewState.showDownScrollArrow,
                onStartChatPressed: () => _onStartChatPressed(context),
                isChatStarted: chatState.isSubscribed,
              );
            },
          );
        },
      ),
    );
  }
}

class SupportPageState {
  final bool showDownScrollArrow;

  SupportPageState({this.showDownScrollArrow = false});
}

class SupportPageCubit extends Cubit<SupportPageState> {
  SupportPageCubit() : super(SupportPageState());

  void showArrow() {
    emit(SupportPageState(showDownScrollArrow: true));
  }

  void hideArrow() {
    emit(SupportPageState(showDownScrollArrow: false));
  }
}
